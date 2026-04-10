// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_judge_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(judgeHistoryStream)
final judgeHistoryStreamProvider = JudgeHistoryStreamProvider._();

final class JudgeHistoryStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JudgeHistory>>,
          List<JudgeHistory>,
          Stream<List<JudgeHistory>>
        >
    with
        $FutureModifier<List<JudgeHistory>>,
        $StreamProvider<List<JudgeHistory>> {
  JudgeHistoryStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'judgeHistoryStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$judgeHistoryStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<JudgeHistory>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<JudgeHistory>> create(Ref ref) {
    return judgeHistoryStream(ref);
  }
}

String _$judgeHistoryStreamHash() =>
    r'36a3582c27ae7cd97841833f1f25abff282da2de';
