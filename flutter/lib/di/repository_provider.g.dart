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

@ProviderFor(scoreRepository)
final scoreRepositoryProvider = ScoreRepositoryProvider._();

final class ScoreRepositoryProvider
    extends
        $FunctionalProvider<ScoreRepository, ScoreRepository, ScoreRepository>
    with $Provider<ScoreRepository> {
  ScoreRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scoreRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scoreRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScoreRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScoreRepository create(Ref ref) {
    return scoreRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoreRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoreRepository>(value),
    );
  }
}

String _$scoreRepositoryHash() => r'6518948e377e97724024e99114898601a9620747';
