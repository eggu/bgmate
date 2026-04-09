import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_history.freezed.dart';

@freezed
sealed class SessionHistory with _$SessionHistory {
  const factory SessionHistory({
    required int id,
    required BoardGame game,
    required List<PlayerScore> scores,
    required DateTime playedAt,
  }) = _SessionHistory;
}
