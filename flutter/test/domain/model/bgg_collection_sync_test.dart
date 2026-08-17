import 'package:bgmate_flutter/domain/model/bgg_collection_sync.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BggCollectionSync.fromApiJson', () {
    test('Bgmate BGG collection 성공 응답을 앱 모델로 변환한다', () {
      final sync = BggCollectionSync.fromApiJson({
        'ok': true,
        'source': 'bgg',
        'username': 'example',
        'games': [
          {
            'bggId': 13,
            'name': 'Catan',
            'originalName': 'Catan',
            'yearPublished': 1995,
            'thumbnail': 'https://example.com/thumb.jpg',
            'image': 'https://example.com/image.jpg',
            'owned': true,
            'isExpansion': false,
            'playCount': 5,
            'lastPlayedAt': '2026-06-01',
            'rating': 7.2,
          },
        ],
        'syncedAt': '2026-07-02T00:00:00.000Z',
      });

      expect(sync.username, 'example');
      expect(sync.syncedAt, DateTime.parse('2026-07-02T00:00:00.000Z'));
      expect(sync.games, hasLength(1));
      expect(sync.games.single.game.bggId, 13);
      expect(sync.games.single.game.name, 'Catan');
      expect(sync.games.single.game.yearPublished, 1995);
      expect(sync.games.single.playCount, 5);
      expect(sync.games.single.lastPlayedAt, DateTime(2026, 6, 1));
      expect(sync.games.single.rating, 7.2);
      expect(sync.games.single.isExpansion, isFalse);
    });

    test('yearPublished, lastPlayedAt, rating이 없으면 앱 기본값과 null로 변환한다', () {
      final sync = BggCollectionSync.fromApiJson({
        'ok': true,
        'username': 'example',
        'games': [
          {
            'bggId': 1,
            'name': 'No Year',
            'yearPublished': null,
            'playCount': 0,
            'lastPlayedAt': null,
            'rating': null,
          },
        ],
        'syncedAt': '2026-07-02T00:00:00.000Z',
      });

      expect(sync.games.single.game.yearPublished, 0);
      expect(sync.games.single.lastPlayedAt, isNull);
      expect(sync.games.single.rating, isNull);
    });

    test('isExpansion을 전적 통계로 넘긴다', () {
      final sync = BggCollectionSync.fromApiJson({
        'ok': true,
        'username': 'example',
        'games': [
          {
            'bggId': 2,
            'name': 'Expansion',
            'isExpansion': true,
            'playCount': 1,
          },
        ],
        'syncedAt': '2026-07-02T00:00:00.000Z',
      });

      expect(sync.games.single.isExpansion, isTrue);
      expect(sync.games.single.toStats().isExpansion, isTrue);
    });
  });
}
