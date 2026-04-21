import 'package:bgmate_flutter/data/repository/account_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AccountRepositoryImpl repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = AccountRepositoryImpl(prefs);
  });

  group('AccountRepositoryImpl', () {
    test('연동 전 getAccount() → null', () async {
      expect(await repo.getAccount(), isNull);
    });

    test('linkAccount 후 getAccount() → 저장된 계정 반환', () async {
      await repo.linkAccount('testuser');
      final account = await repo.getAccount();

      expect(account, isNotNull);
      expect(account!.username, equals('testuser'));
      expect(account.linkedAt, isNotNull);
      expect(account.lastSyncedAt, isNull);
    });

    test('linkAccount 재호출 시 기존 계정 교체', () async {
      await repo.linkAccount('olduser');
      await repo.linkAccount('newuser');
      final account = await repo.getAccount();

      expect(account!.username, equals('newuser'));
    });

    test('updateLastSyncedAt 후 lastSyncedAt 반영됨', () async {
      await repo.linkAccount('testuser');
      final syncedAt = DateTime(2025, 4, 21, 12, 0);
      await repo.updateLastSyncedAt(syncedAt);

      final account = await repo.getAccount();
      expect(
        account!.lastSyncedAt!.millisecondsSinceEpoch,
        equals(syncedAt.millisecondsSinceEpoch),
      );
    });

    test('unlinkAccount 후 getAccount() → null', () async {
      await repo.linkAccount('testuser');
      await repo.unlinkAccount();

      expect(await repo.getAccount(), isNull);
    });

    test('unlinkAccount 후 재연동 가능', () async {
      await repo.linkAccount('user1');
      await repo.unlinkAccount();
      await repo.linkAccount('user2');

      final account = await repo.getAccount();
      expect(account!.username, equals('user2'));
    });
  });
}
