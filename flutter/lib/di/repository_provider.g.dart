// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameRepository)
final gameRepositoryProvider = GameRepositoryProvider._();

final class GameRepositoryProvider
    extends $FunctionalProvider<GameRepository, GameRepository, GameRepository>
    with $Provider<GameRepository> {
  GameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameRepositoryHash();

  @$internal
  @override
  $ProviderElement<GameRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameRepository create(Ref ref) {
    return gameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameRepository>(value),
    );
  }
}

String _$gameRepositoryHash() => r'ddcfe9bb6e89ec38effdd1fc2d08a094b64cdfb5';

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'f24db31a1ef6dea8b23b8b7df22832e1cba8b70c';

@ProviderFor(ruleJudgeRepository)
final ruleJudgeRepositoryProvider = RuleJudgeRepositoryProvider._();

final class RuleJudgeRepositoryProvider
    extends
        $FunctionalProvider<
          RuleJudgeRepository,
          RuleJudgeRepository,
          RuleJudgeRepository
        >
    with $Provider<RuleJudgeRepository> {
  RuleJudgeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ruleJudgeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ruleJudgeRepositoryHash();

  @$internal
  @override
  $ProviderElement<RuleJudgeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RuleJudgeRepository create(Ref ref) {
    return ruleJudgeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RuleJudgeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RuleJudgeRepository>(value),
    );
  }
}

String _$ruleJudgeRepositoryHash() =>
    r'33a8f5e71e3f03c5db8c9d8db482a073e25dccec';

@ProviderFor(recommendRepository)
final recommendRepositoryProvider = RecommendRepositoryProvider._();

final class RecommendRepositoryProvider
    extends
        $FunctionalProvider<
          RecommendRepository,
          RecommendRepository,
          RecommendRepository
        >
    with $Provider<RecommendRepository> {
  RecommendRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommendRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommendRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecommendRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecommendRepository create(Ref ref) {
    return recommendRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecommendRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecommendRepository>(value),
    );
  }
}

String _$recommendRepositoryHash() =>
    r'89bd2ad443c0348f966843cb2d059017ccc21284';
