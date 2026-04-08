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
        'Use .env.local with --dart-define-from-file or pass '
        '--dart-define=BGG_API_TOKEN=...',
      );
    }
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
