import 'dart:async';
import 'dart:convert';

import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_response.dart';
import 'package:dio/dio.dart';

class GeminiLlmClient implements LlmClient {
  final Dio _dio;
  final String _apiKey;

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
    final response = await _dio.post<Map<String, dynamic>>(
      _generateContentUrl,
      data: _buildRequestBody(request),
      options: Options(
        headers: {
          'x-goog-api-key': _apiKey,
          'content-type': 'application/json',
        },
      ),
    );

    return LlmResponse(text: _extractText(response.data ?? {}));
  }

  @override
  Stream<String> stream(LlmRequest request) async* {
    final response = await _dio.post<ResponseBody>(
      _streamGenerateContentUrl,
      data: _buildRequestBody(request),
      options: Options(
        headers: {
          'x-goog-api-key': _apiKey,
          'content-type': 'application/json',
        },
        responseType: ResponseType.stream,
      ),
    );

    final lines = response.data!.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;

      final data = line.substring('data: '.length);
      final chunk = _extractTextSafe(data);
      if (chunk.isNotEmpty) yield chunk;
    }
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
