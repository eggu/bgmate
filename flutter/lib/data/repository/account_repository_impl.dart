import 'package:bgmate_flutter/domain/model/bgg_account.dart';
import 'package:bgmate_flutter/domain/repository/account_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepositoryImpl implements AccountRepository {
  static const _keyUsername = 'bgg_account_username';
  static const _keyLinkedAt = 'bgg_account_linked_at';
  static const _keyLastSyncedAt = 'bgg_account_last_synced_at';

  final SharedPreferences _prefs;

  AccountRepositoryImpl(this._prefs);

  @override
  Future<BggAccount?> getAccount() async {
    final username = _prefs.getString(_keyUsername);
    final linkedAtMs = _prefs.getInt(_keyLinkedAt);
    if (username == null || linkedAtMs == null) return null;

    final lastSyncedAtMs = _prefs.getInt(_keyLastSyncedAt);
    return BggAccount(
      username: username,
      linkedAt: DateTime.fromMillisecondsSinceEpoch(linkedAtMs),
      lastSyncedAt: lastSyncedAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(lastSyncedAtMs)
          : null,
    );
  }

  @override
  Future<void> linkAccount(String username) async {
    await _prefs.setString(_keyUsername, username);
    await _prefs.setInt(_keyLinkedAt, DateTime.now().millisecondsSinceEpoch);
    await _prefs.remove(_keyLastSyncedAt);
  }

  @override
  Future<void> updateLastSyncedAt(DateTime syncedAt) async {
    await _prefs.setInt(_keyLastSyncedAt, syncedAt.millisecondsSinceEpoch);
  }

  @override
  Future<void> unlinkAccount() async {
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyLinkedAt);
    await _prefs.remove(_keyLastSyncedAt);
  }
}
