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

@ProviderFor(sessionDao)
final sessionDaoProvider = SessionDaoProvider._();

final class SessionDaoProvider
    extends $FunctionalProvider<SessionDao, SessionDao, SessionDao>
    with $Provider<SessionDao> {
  SessionDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionDaoHash();

  @$internal
  @override
  $ProviderElement<SessionDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionDao create(Ref ref) {
    return sessionDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionDao>(value),
    );
  }
}

String _$sessionDaoHash() => r'5b9f815efbadc4a121e39a35b15781d3f61be6c9';

@ProviderFor(judgeHistoryDao)
final judgeHistoryDaoProvider = JudgeHistoryDaoProvider._();

final class JudgeHistoryDaoProvider
    extends
        $FunctionalProvider<JudgeHistoryDao, JudgeHistoryDao, JudgeHistoryDao>
    with $Provider<JudgeHistoryDao> {
  JudgeHistoryDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'judgeHistoryDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$judgeHistoryDaoHash();

  @$internal
  @override
  $ProviderElement<JudgeHistoryDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JudgeHistoryDao create(Ref ref) {
    return judgeHistoryDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JudgeHistoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JudgeHistoryDao>(value),
    );
  }
}

String _$judgeHistoryDaoHash() => r'ccd51ea300afbbf6a4ddc17a5c8884be4ed388d0';

@ProviderFor(gamePlayStatsDao)
final gamePlayStatsDaoProvider = GamePlayStatsDaoProvider._();

final class GamePlayStatsDaoProvider
    extends
        $FunctionalProvider<
          GamePlayStatsDao,
          GamePlayStatsDao,
          GamePlayStatsDao
        >
    with $Provider<GamePlayStatsDao> {
  GamePlayStatsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamePlayStatsDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamePlayStatsDaoHash();

  @$internal
  @override
  $ProviderElement<GamePlayStatsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GamePlayStatsDao create(Ref ref) {
    return gamePlayStatsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GamePlayStatsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GamePlayStatsDao>(value),
    );
  }
}

String _$gamePlayStatsDaoHash() => r'01fda34cbfa7fc82fbee037aa23d8b7860656ade';

@ProviderFor(appSettingsDao)
final appSettingsDaoProvider = AppSettingsDaoProvider._();

final class AppSettingsDaoProvider
    extends $FunctionalProvider<AppSettingsDao, AppSettingsDao, AppSettingsDao>
    with $Provider<AppSettingsDao> {
  AppSettingsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsDaoHash();

  @$internal
  @override
  $ProviderElement<AppSettingsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppSettingsDao create(Ref ref) {
    return appSettingsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettingsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettingsDao>(value),
    );
  }
}

String _$appSettingsDaoHash() => r'14ddadbc5741fe493fb1eb57bd5f3931224000ac';
