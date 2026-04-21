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

String _$gameListNotifierHash() => r'604e368fd140bb67831fbd7412758c7380b180d3';

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
