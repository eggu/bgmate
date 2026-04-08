// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

@ProviderFor(gameDao)
final gameDaoProvider = GameDaoProvider._();

final class GameDaoProvider
    extends $FunctionalProvider<GameDao, GameDao, GameDao>
    with $Provider<GameDao> {
  GameDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameDaoHash();

  @$internal
  @override
  $ProviderElement<GameDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameDao create(Ref ref) {
    return gameDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameDao>(value),
    );
  }
}

String _$gameDaoHash() => r'2e56370f1d0cedb85db8cad3cfa38d81dc07b29d';
