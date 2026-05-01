// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountRepository>,
          AccountRepository,
          FutureOr<AccountRepository>
        >
    with
        $FutureModifier<AccountRepository>,
        $FutureProvider<AccountRepository> {
  AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountRepository> create(Ref ref) {
    return accountRepository(ref);
  }
}

String _$accountRepositoryHash() => r'eb765c0dc43fdad41f0a11e48217cbd7d5349d00';

@ProviderFor(AccountNotifier)
final accountProvider = AccountNotifierProvider._();

final class AccountNotifierProvider
    extends $AsyncNotifierProvider<AccountNotifier, BggAccount?> {
  AccountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountNotifierHash();

  @$internal
  @override
  AccountNotifier create() => AccountNotifier();
}

String _$accountNotifierHash() => r'1f7a5c645c8a0a6b7b10e8a3ebb3573d5ca4932a';

abstract class _$AccountNotifier extends $AsyncNotifier<BggAccount?> {
  FutureOr<BggAccount?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BggAccount?>, BggAccount?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BggAccount?>, BggAccount?>,
              AsyncValue<BggAccount?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CollectionSyncNotifier)
final collectionSyncProvider = CollectionSyncNotifierProvider._();

final class CollectionSyncNotifierProvider
    extends $NotifierProvider<CollectionSyncNotifier, AsyncValue<SyncStep?>> {
  CollectionSyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionSyncNotifierHash();

  @$internal
  @override
  CollectionSyncNotifier create() => CollectionSyncNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SyncStep?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SyncStep?>>(value),
    );
  }
}

String _$collectionSyncNotifierHash() =>
    r'eacfa4f9a65afcca0aa17ea30e56117d0da8681b';

abstract class _$CollectionSyncNotifier
    extends $Notifier<AsyncValue<SyncStep?>> {
  AsyncValue<SyncStep?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SyncStep?>, AsyncValue<SyncStep?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SyncStep?>, AsyncValue<SyncStep?>>,
              AsyncValue<SyncStep?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
