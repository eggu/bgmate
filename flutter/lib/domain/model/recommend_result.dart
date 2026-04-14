import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommend_result.freezed.dart';

@freezed
sealed class RecommendResult with _$RecommendResult {
  const factory RecommendResult({
    required String name,
    required String reason,
    required bool isOwned,
    @Default(null) double? bggScore,
    @Default(null) String? difficulty,
  }) = _RecommendResult;
}
