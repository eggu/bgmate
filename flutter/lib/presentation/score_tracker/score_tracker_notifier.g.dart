// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_tracker_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScoreTrackerNotifier)
final scoreTrackerProvider = ScoreTrackerNotifierFamily._();

final class ScoreTrackerNotifierProvider
    extends $NotifierProvider<ScoreTrackerNotifier, ScoreTrackerState> {
  ScoreTrackerNotifierProvider._({
    required ScoreTrackerNotifierFamily super.from,
    required (int, List<String>) super.argument,
  }) : super(
         retry: null,
         name: r'scoreTrackerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scoreTrackerNotifierHash();

  @override
  String toString() {
    return r'scoreTrackerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ScoreTrackerNotifier create() => ScoreTrackerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoreTrackerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoreTrackerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScoreTrackerNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scoreTrackerNotifierHash() =>
    r'fd7411b1a563c921adfae740289fd5af34d06f06';

final class ScoreTrackerNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ScoreTrackerNotifier,
          ScoreTrackerState,
          ScoreTrackerState,
          ScoreTrackerState,
          (int, List<String>)
        > {
  ScoreTrackerNotifierFamily._()
    : super(
        retry: null,
        name: r'scoreTrackerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ScoreTrackerNotifierProvider call(int bggId, List<String> playerNames) =>
      ScoreTrackerNotifierProvider._(
        argument: (bggId, playerNames),
        from: this,
      );

  @override
  String toString() => r'scoreTrackerProvider';
}

abstract class _$ScoreTrackerNotifier extends $Notifier<ScoreTrackerState> {
  late final _$args = ref.$arg as (int, List<String>);
  int get bggId => _$args.$1;
  List<String> get playerNames => _$args.$2;

  ScoreTrackerState build(int bggId, List<String> playerNames);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ScoreTrackerState, ScoreTrackerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScoreTrackerState, ScoreTrackerState>,
              ScoreTrackerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
