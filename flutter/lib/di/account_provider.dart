import 'package:bgmate_flutter/data/repository/account_repository_impl.dart';
import 'package:bgmate_flutter/data/service/collection_sync_service.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/bgg_account.dart';
import 'package:bgmate_flutter/domain/repository/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'account_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AccountRepository> accountRepository(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return AccountRepositoryImpl(prefs);
}

@riverpod
class AccountNotifier extends _$AccountNotifier {
  @override
  Future<BggAccount?> build() async {
    final repo = await ref.watch(accountRepositoryProvider.future);
    return repo.getAccount();
  }

  Future<void> linkAccount(String username) async {
    final repo = await ref.read(accountRepositoryProvider.future);
    await repo.linkAccount(username);
    ref.invalidateSelf();
  }

  Future<void> unlinkAccount() async {
    final repo = await ref.read(accountRepositoryProvider.future);
    await repo.unlinkAccount();
    ref.invalidateSelf();
  }
}

@riverpod
class CollectionSyncNotifier extends _$CollectionSyncNotifier {
  @override
  AsyncValue<SyncStep?> build() => const AsyncData(null);

  Future<CollectionSyncResult?> sync(String username) async {
    final service = CollectionSyncService(
      ref.read(bggApiServiceProvider),
      ref.read(gameRepositoryProvider),
      await ref.read(accountRepositoryProvider.future),
    );

    state = const AsyncLoading();
    try {
      final result = await service.sync(
        username,
        onProgress: (step) => state = AsyncData(step),
      );
      state = const AsyncData(SyncStep.done);
      ref.invalidate(accountProvider);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
