import 'package:bgmate_flutter/domain/model/bgg_account.dart';

abstract interface class AccountRepository {
  Future<BggAccount?> getAccount();

  Future<void> linkAccount(String username);

  Future<void> updateLastSyncedAt(DateTime syncedAt);

  Future<void> unlinkAccount();
}
