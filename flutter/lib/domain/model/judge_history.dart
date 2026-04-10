import 'package:freezed_annotation/freezed_annotation.dart';

part 'judge_history.freezed.dart';

@freezed
sealed class JudgeHistory with _$JudgeHistory {
  const factory JudgeHistory({
    required int id,
    required String gameName,
    required String question,
    required String answer,
    required DateTime askedAt,
  }) = _JudgeHistory;
}
