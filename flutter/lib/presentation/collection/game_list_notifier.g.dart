// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameListNotifier)
final gameListProvider = GameListNotifierProvider._();

final class GameListNotifierProvider
    extends $AsyncNotifierProvider<GameListNotifier, List<BoardGame>> {
  GameListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameListNotifierHash();

  @$internal
  @override
  GameListNotifier create() => GameListNotifier();
}

String _$gameListNotifierHash() => r'c9360e92903da60cb690a00b0875141640b71d17';

abstract class _$GameListNotifier extends $AsyncNotifier<List<BoardGame>> {
  FutureOr<List<BoardGame>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<BoardGame>>, List<BoardGame>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BoardGame>>, List<BoardGame>>,
              AsyncValue<List<BoardGame>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(GameListSortOption)
final gameListSortOptionProvider = GameListSortOptionProvider._();

final class GameListSortOptionProvider
    extends $NotifierProvider<GameListSortOption, SortOption> {
  GameListSortOptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameListSortOptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameListSortOptionHash();

  @$internal
  @override
  GameListSortOption create() => GameListSortOption();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortOption>(value),
    );
  }
}

String _$gameListSortOptionHash() =>
    r'bb98e58905bae2760a1d5a9a2fa9abe010320181';

abstract class _$GameListSortOption extends $Notifier<SortOption> {
  SortOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SortOption, SortOption>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortOption, SortOption>,
              SortOption,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
