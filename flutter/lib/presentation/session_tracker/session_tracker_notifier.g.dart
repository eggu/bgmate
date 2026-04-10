// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_tracker_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionTrackerNotifier)
final sessionTrackerProvider = SessionTrackerNotifierFamily._();

final class SessionTrackerNotifierProvider
    extends $NotifierProvider<SessionTrackerNotifier, SessionTrackerState> {
  SessionTrackerNotifierProvider._({
    required SessionTrackerNotifierFamily super.from,
    required (int, List<String>) super.argument,
  }) : super(
         retry: null,
         name: r'sessionTrackerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionTrackerNotifierHash();

  @override
  String toString() {
    return r'sessionTrackerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SessionTrackerNotifier create() => SessionTrackerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionTrackerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionTrackerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SessionTrackerNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionTrackerNotifierHash() =>
    r'15b1c79d4f089d475a71c1bddc947dc705dc5522';

final class SessionTrackerNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SessionTrackerNotifier,
          SessionTrackerState,
          SessionTrackerState,
          SessionTrackerState,
          (int, List<String>)
        > {
  SessionTrackerNotifierFamily._()
    : super(
        retry: null,
        name: r'sessionTrackerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionTrackerNotifierProvider call(int bggId, List<String> playerNames) =>
      SessionTrackerNotifierProvider._(
        argument: (bggId, playerNames),
        from: this,
      );

  @override
  String toString() => r'sessionTrackerProvider';
}

abstract class _$SessionTrackerNotifier extends $Notifier<SessionTrackerState> {
  late final _$args = ref.$arg as (int, List<String>);
  int get bggId => _$args.$1;
  List<String> get playerNames => _$args.$2;

  SessionTrackerState build(int bggId, List<String> playerNames);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SessionTrackerState, SessionTrackerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionTrackerState, SessionTrackerState>,
              SessionTrackerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
