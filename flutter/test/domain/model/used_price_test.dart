import 'package:bgmate_flutter/domain/model/used_price.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UsedPrice.fromApiJson', () {
    test('Bgmate used-price 성공 응답을 앱 모델로 변환한다', () {
      final price = UsedPrice.fromApiJson({
        'ok': true,
        'source': 'boardlife',
        'bggId': 13,
        'boardlifeId': '274',
        'boardlifeName': '카탄의 개척자',
        'shopUrl': 'https://boardlife.co.kr/game/274/shop',
        'minPrice': 10000,
        'maxPrice': 30000,
        'avgPrice': 28368,
        'listingCount': 19,
        'cachedAt': '2026-06-22T07:53:09.235Z',
      });

      expect(price, isNotNull);
      expect(price!.bggId, 13);
      expect(price.boardlifeId, '274');
      expect(price.boardlifeName, '카탄의 개척자');
      expect(price.minPrice, 10000);
      expect(price.maxPrice, 30000);
      expect(price.avgPrice, 28368);
      expect(price.listingCount, 19);
      expect(price.cachedAt, DateTime.parse('2026-06-22T07:53:09.235Z'));
      expect(price.shopUri.toString(), 'https://boardlife.co.kr/game/274/shop');
    });

    test('매칭 실패 응답은 null을 반환한다', () {
      final price = UsedPrice.fromApiJson({
        'ok': false,
        'error': '보드라이프에서 게임을 찾지 못했습니다',
      });

      expect(price, isNull);
    });
  });
}
