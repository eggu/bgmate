import 'package:dio/dio.dart';

class BggApiService {
  static const _baseUrl = 'https://boardgamegeek.com/xmlapi2';
  static const _token = String.fromEnvironment('BGG_API_TOKEN');

  final Dio _dio;

  BggApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          headers: {'Authorization': 'Bearer $_token'},
        ),
      ) {
    if (_token.isEmpty) {
      throw StateError(
        'BGG_API_TOKEN is missing. '
        'Use dart_define.json with --dart-define-from-file or pass '
        '--dart-define=BGG_API_TOKEN=...',
      );
    }
  }

  /// BGG 컬렉션을 가져옵니다. 202 응답 시 최대 [maxRetries]회 재시도합니다.
  Future<String> fetchCollection(
    String username, {
    int maxRetries = 5,
    Duration retryDelay = const Duration(seconds: 3),
  }) async {
    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      final response = await _dio.get<String>(
        '/collection',
        queryParameters: {'username': username, 'stats': 1},
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) return response.data ?? '';

      if (response.statusCode == 202 && attempt < maxRetries) {
        await Future.delayed(retryDelay);
        continue;
      }

      throw Exception(
        'BGG collection fetch failed (status ${response.statusCode}) '
        'after ${attempt + 1} attempt(s)',
      );
    }
    throw Exception('BGG collection not ready after $maxRetries retries');
  }

  Future<String> fetchThingDetails(List<int> ids) async {
    // ids를 리터럴 콤마로 연결 — queryParameters 사용 시 %2C로 인코딩되므로 URL 직접 구성
    final idParam = ids.join(',');
    final response = await _dio.get<String>(
      '/thing?id=$idParam&type=boardgame',
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }

  Future<String> searchGames(String query) async {
    final response = await _dio.get<String>(
      '/search',
      queryParameters: {'query': query, 'type': 'boardgame'},
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }
}
