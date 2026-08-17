import 'package:bgmate_flutter/data/remote/used_price_api_service.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UsedPriceApiService.usedPriceUri', () {
    test('base URL 뒤에 Bgmate 중고가 API 경로와 query를 붙인다', () {
      final uri = UsedPriceApiService.usedPriceUri(
        baseUrl: 'https://bgcut.example.com/',
        name: '카탄',
        bggId: 13,
        originalName: 'Catan',
      );

      expect(
        '${uri.scheme}://${uri.host}${uri.path}',
        'https://bgcut.example.com/api/bgmate/used-price',
      );
      expect(uri.queryParameters, {
        'name': '카탄',
        'bggId': '13',
        'originalName': 'Catan',
      });
    });
  });

  test('wrapper 성공 응답을 가격 모델로 변환한다', () async {
    final adapter = _FakeAdapter({
      '/api/bgmate/used-price': '''
        {
          "ok": true,
          "source": "boardlife",
          "bggId": 13,
          "boardlifeId": "274",
          "boardlifeName": "카탄의 개척자",
          "shopUrl": "https://boardlife.co.kr/game/274/shop",
          "minPrice": 10000,
          "maxPrice": 30000,
          "avgPrice": 20000,
          "listingCount": 2,
          "cachedAt": "2026-06-22T07:53:09.235Z"
        }
      ''',
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = UsedPriceApiService(
      dio: dio,
      baseUrl: 'https://bgcut.example.com',
    );

    final price = await service.fetchUsedPrice(
      const BoardGame(bggId: 13, name: '카탄', yearPublished: 1995),
      originalName: 'Catan',
    );

    expect(price?.boardlifeId, '274');
    expect(price?.boardlifeName, '카탄의 개척자');
    expect(price?.minPrice, 10000);
    expect(price?.maxPrice, 30000);
    expect(price?.avgPrice, 20000);
    expect(price?.listingCount, 2);
    expect(adapter.urls.first.queryParameters, {
      'name': '카탄',
      'bggId': '13',
      'originalName': 'Catan',
    });
    expect(adapter.urls, hasLength(1));
  });

  test('wrapper 미매칭이면 Boardlife를 직접 호출하지 않고 null을 반환한다', () async {
    final adapter = _FakeAdapter({
      '/api/bgmate/used-price': '{"ok":false,"error":"보드라이프에서 게임을 찾지 못했습니다"}',
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = UsedPriceApiService(
      dio: dio,
      baseUrl: 'https://bgcut.example.com',
    );

    final price = await service.fetchUsedPrice(
      const BoardGame(bggId: 13, name: '카탄', yearPublished: 1995),
      originalName: 'Catan',
    );

    expect(price, isNull);
    expect(adapter.urls, hasLength(1));
  });
}

class _FakeAdapter implements HttpClientAdapter {
  final Map<String, String> responses;
  final urls = <Uri>[];

  _FakeAdapter(this.responses);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    urls.add(options.uri);
    final body = responses[options.uri.path];
    if (body == null) {
      return ResponseBody.fromString('not found', 404);
    }
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [
          options.uri.path == '/api/bgmate/used-price'
              ? Headers.jsonContentType
              : Headers.textPlainContentType,
        ],
      },
    );
  }
}
