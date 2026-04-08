import 'package:freezed_annotation/freezed_annotation.dart';

part 'judge_result.freezed.dart';

@freezed
sealed class JudgeResult with _$JudgeResult {
  const factory JudgeResult({
    required String id,
    required String question,
    required String answer,
    required DateTime createdAt,
  }) = _JudgeResult;
}
