// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameDetail)
final gameDetailProvider = GameDetailFamily._();

final class GameDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<BoardGame?>,
          BoardGame?,
          FutureOr<BoardGame?>
        >
    with $FutureModifier<BoardGame?>, $FutureProvider<BoardGame?> {
  GameDetailProvider._({
    required GameDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'gameDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameDetailHash();

  @override
  String toString() {
    return r'gameDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BoardGame?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<BoardGame?> create(Ref ref) {
    final argument = this.argument as int;
    return gameDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GameDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameDetailHash() => r'5ea8f14bd8acbbc9d58d9f573a5b254850778585';

final class GameDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BoardGame?>, int> {
  GameDetailFamily._()
    : super(
        retry: null,
        name: r'gameDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameDetailProvider call(int bggId) =>
      GameDetailProvider._(argument: bggId, from: this);

  @override
  String toString() => r'gameDetailProvider';
}
