import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_score.freezed.dart';

@freezed
sealed class PlayerScore with _$PlayerScore {
  const factory PlayerScore({
    required int id,
    required int sessionId,
    required String playerName,
    required int score,
  }) = _PlayerScore;
}
