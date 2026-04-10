import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_response.dart';
import 'package:dio/dio.dart';

class GeminiLlmClient implements LlmClient {
  final Dio _dio;
  final String _apiKey;

  static const _tag = 'GeminiLlmClient';
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash';
  static const _generateContentUrl = '$_baseUrl:generateContent';
  static const _streamGenerateContentUrl =
      '$_baseUrl:streamGenerateContent?alt=sse';

  GeminiLlmClient({required Dio dio, required String apiKey})
      : _dio = dio,
        _apiKey = apiKey;

  // Gemini는 assistant role을 "model"로 사용
  static String _mapRole(String role) =>
      role == 'assistant' ? 'model' : role;

  @override
  Future<LlmResponse> complete(LlmRequest request) async {
    final body = _buildRequestBody(request);
    dev.log('→ complete request: ${jsonEncode(body)}', name: _tag);

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _generateContentUrl,
        data: body,
        options: Options(
          headers: {
            'x-goog-api-key': _apiKey,
            'content-type': 'application/json',
          },
        ),
      );
      dev.log('← complete ${response.statusCode}: ${jsonEncode(response.data)}',
          name: _tag);
      return LlmResponse(text: _extractText(response.data ?? {}));
    } on DioException catch (e) {
      dev.log(
        '✗ complete error ${e.response?.statusCode}: ${e.response?.data}',
        name: _tag,
        error: e,
      );
      rethrow;
    }
  }

  @override
  Stream<String> stream(LlmRequest request) async* {
    final body = _buildRequestBody(request);
    dev.log('→ stream request: ${jsonEncode(body)}', name: _tag);

    final Response<ResponseBody> response;
    try {
      response = await _retryOnOverload(() => _dio.post<ResponseBody>(
        _streamGenerateContentUrl,
        data: body,
        options: Options(
          headers: {
            'x-goog-api-key': _apiKey,
            'content-type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
      ));
    } on DioException catch (e) {
      dev.log(
        '✗ stream error ${e.response?.statusCode}: ${e.response?.data}',
        name: _tag,
        error: e,
      );
      rethrow;
    }

    dev.log('← stream connected (status ${response.statusCode})', name: _tag);

    final lines = response.data!.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      dev.log('  SSE: $line', name: _tag);
      if (!line.startsWith('data: ')) continue;

      final data = line.substring('data: '.length);
      final chunk = _extractTextSafe(data);
      if (chunk.isNotEmpty) yield chunk;
    }
  }

  /// 503/429 응답 시 지수 백오프로 최대 [maxAttempts]회 재시도합니다.
  Future<T> _retryOnOverload<T>(
    Future<T> Function() call, {
    int maxAttempts = 3,
  }) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await call();
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final retryable = status == 503 || status == 429;
        if (!retryable || attempt == maxAttempts) rethrow;

        final delay = Duration(seconds: 1 << (attempt - 1)); // 1s, 2s, 4s
        dev.log(
          '↻ attempt $attempt failed ($status), retrying in ${delay.inSeconds}s…',
          name: _tag,
        );
        await Future<void>.delayed(delay);
      }
    }
    throw StateError('unreachable');
  }

  Map<String, dynamic> _buildRequestBody(LlmRequest request) {
    return {
      if (request.systemPrompt != null)
        'systemInstruction': {
          'parts': [
            {'text': request.systemPrompt},
          ],
        },
      'contents': [
        for (final msg in request.messages)
          {
            'role': _mapRole(msg.role),
            'parts': [
              {'text': msg.content},
            ],
          },
      ],
      'generationConfig': {'maxOutputTokens': request.maxTokens},
    };
  }

  String _extractText(Map<String, dynamic> root) {
    final candidates = root['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return '';

    final candidate = candidates[0] as Map<String, dynamic>;
    final content = candidate['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null) return '';

    // gemini-2.5-flash는 사고(thinking) 파트를 포함할 수 있음.
    // thought=true 파트는 내부 추론이므로 제외하고 실제 응답만 추출.
    return parts
        .whereType<Map<String, dynamic>>()
        .where((part) => part['thought'] != true)
        .map((part) => part['text'] as String? ?? '')
        .join();
  }

  String _extractTextSafe(String responseBody) {
    try {
      final root = jsonDecode(responseBody) as Map<String, dynamic>;
      return _extractText(root);
    } catch (_) {
      return '';
    }
  }
}
