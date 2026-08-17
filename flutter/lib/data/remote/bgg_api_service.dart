import 'dart:async';

import 'package:dio/dio.dart';

class BggApiService {
  static const _baseUrl = 'https://boardgamegeek.com/xmlapi2';
  static const _defaultToken = String.fromEnvironment('BGG_API_TOKEN');
  static const _collectionMaxRetries = 10;
  static const _collectionRetryDelay = Duration(seconds: 3);

  final Dio _dio;
  final String _token;

  BggApiService({Dio? dio, String token = _defaultToken})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl)),
      _token = token.trim() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Accept'] = 'application/xml';
    if (_token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  bool get isConfigured => _token.isNotEmpty;

  Future<String> fetchThingDetails(List<int> ids) async {
    _ensureConfigured();
    // ids를 리터럴 콤마로 연결 — queryParameters 사용 시 %2C로 인코딩되므로 URL 직접 구성
    final idParam = ids.join(',');
    final response = await _dio.get<String>(
      '/thing?id=$idParam&type=boardgame',
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }

  Future<String> searchGames(String query) async {
    _ensureConfigured();
    final response = await _dio.get<String>(
      '/search',
      queryParameters: {'query': query, 'type': 'boardgame'},
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }

  Future<String> fetchCollection({
    required String username,
    required String subtype,
  }) async {
    _ensureConfigured();
    final uri = collectionUri(username: username, subtype: subtype);

    for (var attempt = 0; attempt < _collectionMaxRetries; attempt++) {
      final response = await _dio.getUri<String>(
        uri,
        options: _plainResponseOptions(),
      );
      final statusCode = response.statusCode ?? 0;
      if (statusCode == 202) {
        await Future<void>.delayed(_collectionRetryDelay);
        continue;
      }
      if (statusCode < 200 || statusCode >= 300) {
        throw StateError('BGG collection API error: $statusCode');
      }
      final xml = response.data ?? '';
      _throwIfBggError(xml);
      return xml;
    }

    throw StateError(
      'BGG collection API timeout after $_collectionMaxRetries retries.',
    );
  }

  Future<String> fetchPlaysPage({
    required String username,
    int? bggId,
    int page = 1,
  }) async {
    _ensureConfigured();
    final response = await _dio.getUri<String>(
      playsUri(username: username, bggId: bggId, page: page),
      options: _plainResponseOptions(),
    );
    final statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      throw StateError('BGG plays API error: $statusCode');
    }
    final xml = response.data ?? '';
    _throwIfBggError(xml);
    return xml;
  }

  static Uri collectionUri({
    required String username,
    required String subtype,
  }) {
    return Uri.https('boardgamegeek.com', '/xmlapi2/collection', {
      'username': username.trim(),
      'own': '1',
      'stats': '1',
      'subtype': subtype,
    });
  }

  static Uri playsUri({required String username, int? bggId, int page = 1}) {
    final queryParameters = <String, String>{
      'username': username.trim(),
      'page': '$page',
    };
    if (bggId != null) {
      queryParameters['id'] = '$bggId';
    }
    return Uri.https('boardgamegeek.com', '/xmlapi2/plays', queryParameters);
  }

  Options _plainResponseOptions() {
    return Options(
      responseType: ResponseType.plain,
      validateStatus: (status) => status != null && status < 500,
    );
  }

  void _ensureConfigured() {
    if (!isConfigured) {
      throw StateError(
        'BGG_API_TOKEN is missing. '
        'Use dart_define.json with --dart-define-from-file or pass '
        '--dart-define=BGG_API_TOKEN=...',
      );
    }
  }

  void _throwIfBggError(String xml) {
    if (!xml.contains('<error>')) return;
    final messageMatch = RegExp(r'<message>([^<]+)</message>').firstMatch(xml);
    throw StateError(messageMatch?.group(1) ?? 'Unknown BGG API error.');
  }
}
