import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_with_details.freezed.dart';

@freezed
sealed class SessionWithDetails with _$SessionWithDetails {
  const factory SessionWithDetails({
    required SessionRecord session,
    required BoardGameRecord game,
    required List<ScoreWithPlayer> scores,
  }) = _SessionWithDetails;
}

@freezed
sealed class ScoreWithPlayer with _$ScoreWithPlayer {
  const factory ScoreWithPlayer({
    required int id,
    required int sessionId,
    required int score,
    required PlayerRecord player,
    required int rank
  }) = _ScoreWithPlayer;
}
