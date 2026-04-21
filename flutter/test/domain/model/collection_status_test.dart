import 'package:bgmate_flutter/domain/model/collection_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CollectionStatus 직렬화', () {
    test('단일 상태 직렬화', () {
      final statuses = {CollectionStatus.owned};
      expect(statuses.serialize(), equals('owned'));
    });

    test('복수 상태 직렬화 (순서 보존)', () {
      final statuses = {CollectionStatus.owned, CollectionStatus.wantToPlay};
      final serialized = statuses.serialize();
      final parts = serialized.split(',');
      expect(parts, containsAll(['owned', 'wantToPlay']));
    });

    test('빈 Set 직렬화 → 빈 문자열', () {
      final statuses = <CollectionStatus>{};
      expect(statuses.serialize(), equals(''));
    });

    test('빈 문자열 역직렬화 → 빈 Set', () {
      expect(''.toCollectionStatusSet(), isEmpty);
    });

    test('단일 값 역직렬화', () {
      expect('owned'.toCollectionStatusSet(), equals({CollectionStatus.owned}));
    });

    test('복수 값 역직렬화', () {
      final result = 'owned,wishlist'.toCollectionStatusSet();
      expect(result, equals({CollectionStatus.owned, CollectionStatus.wishlist}));
    });

    test('알 수 없는 값은 무시됨', () {
      final result = 'owned,unknownStatus,wantToPlay'.toCollectionStatusSet();
      expect(result, equals({CollectionStatus.owned, CollectionStatus.wantToPlay}));
    });

    test('직렬화 후 역직렬화 왕복 일치', () {
      final original = {
        CollectionStatus.owned,
        CollectionStatus.forTrade,
        CollectionStatus.prevOwned,
      };
      final result = original.serialize().toCollectionStatusSet();
      expect(result, equals(original));
    });
  });
}
