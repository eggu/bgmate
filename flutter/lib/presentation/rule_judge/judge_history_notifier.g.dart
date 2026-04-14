// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'judge_history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JudgeHistoryNotifier)
final judgeHistoryProvider = JudgeHistoryNotifierProvider._();

final class JudgeHistoryNotifierProvider
    extends $StreamNotifierProvider<JudgeHistoryNotifier, List<JudgeHistory>> {
  JudgeHistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'judgeHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$judgeHistoryNotifierHash();

  @$internal
  @override
  JudgeHistoryNotifier create() => JudgeHistoryNotifier();
}

String _$judgeHistoryNotifierHash() =>
    r'7cb5a91c4b5df597c8786c1e1205a2a9eeb9f8a1';

abstract class _$JudgeHistoryNotifier
    extends $StreamNotifier<List<JudgeHistory>> {
  Stream<List<JudgeHistory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<JudgeHistory>>, List<JudgeHistory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<JudgeHistory>>, List<JudgeHistory>>,
              AsyncValue<List<JudgeHistory>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
