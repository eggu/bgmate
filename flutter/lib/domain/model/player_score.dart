import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_score.freezed.dart';

@freezed
sealed class PlayerScore with _$PlayerScore {
  const factory PlayerScore({
    required String playerName,
    required int score,
    @Default(0) int rank,
  }) = _PlayerScore;
}
