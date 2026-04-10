import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_score.freezed.dart';

@freezed
sealed class PlayerScore with _$PlayerScore {
  const factory PlayerScore({
    @Default(0) int id,
    @Default(0) int sessionId,
    required String name,
    @Default(0) int score,
    @Default(0) int rank
  }) = _PlayerScore;
}
