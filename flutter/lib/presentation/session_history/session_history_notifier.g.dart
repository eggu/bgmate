// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionHistoryNotifier)
final sessionHistoryProvider = SessionHistoryNotifierProvider._();

final class SessionHistoryNotifierProvider
    extends
        $StreamNotifierProvider<SessionHistoryNotifier, List<SessionHistory>> {
  SessionHistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHistoryNotifierHash();

  @$internal
  @override
  SessionHistoryNotifier create() => SessionHistoryNotifier();
}

String _$sessionHistoryNotifierHash() =>
    r'08e1daf228003cd9ebdca5721ff4953eb3082d68';

abstract class _$SessionHistoryNotifier
    extends $StreamNotifier<List<SessionHistory>> {
  Stream<List<SessionHistory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<SessionHistory>>, List<SessionHistory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SessionHistory>>,
                List<SessionHistory>
              >,
              AsyncValue<List<SessionHistory>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
