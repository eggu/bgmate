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

String _$gameListNotifierHash() => r'2f2468c7a2f19f162c5eafa1f20f4c9502145ee5';

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
    extends $AsyncNotifierProvider<GameListSortOption, SortOption> {
  GameListSortOptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameListSortOptionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameListSortOptionHash();

  @$internal
  @override
  GameListSortOption create() => GameListSortOption();
}

String _$gameListSortOptionHash() =>
    r'9d59de9ed879b723e36fceec6610e417d01d1fdf';

abstract class _$GameListSortOption extends $AsyncNotifier<SortOption> {
  FutureOr<SortOption> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SortOption>, SortOption>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SortOption>, SortOption>,
              AsyncValue<SortOption>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
