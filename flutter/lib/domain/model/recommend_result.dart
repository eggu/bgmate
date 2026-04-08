import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommend_result.freezed.dart';

@freezed
sealed class RecommendResult with _$RecommendResult {
  const factory RecommendResult({
    required int bggId,
    required String name,
    required String reason,
  }) = _RecommendResult;
}
