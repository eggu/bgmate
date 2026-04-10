// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_judge_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RuleJudgeNotifier)
final ruleJudgeProvider = RuleJudgeNotifierProvider._();

final class RuleJudgeNotifierProvider
    extends $StreamNotifierProvider<RuleJudgeNotifier, List<String>> {
  RuleJudgeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ruleJudgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ruleJudgeNotifierHash();

  @$internal
  @override
  RuleJudgeNotifier create() => RuleJudgeNotifier();
}

String _$ruleJudgeNotifierHash() => r'6aea7c2d0bfce6b8b1b41a54ac1df09f53f48cf2';

abstract class _$RuleJudgeNotifier extends $StreamNotifier<List<String>> {
  Stream<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
