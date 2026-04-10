import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/session_with_details.dart';
import 'package:bgmate_flutter/domain/model/player.dart' as player_model;
import 'package:bgmate_flutter/domain/model/player_score.dart'
    as player_score_model;
import 'package:bgmate_flutter/domain/model/session.dart' as session_model;
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:drift/drift.dart';

import 'game_table_mapper.dart';

extension SessionRecordMapper on SessionRecord {
  session_model.Session toDomain() =>
      session_model.Session(id: id, bggId: bggId, createdAt: createdAt);
}

extension SessionMapper on session_model.Session {
  SessionsCompanion toCompanion() => SessionsCompanion(
    id: Value(id),
    bggId: Value(bggId),
    createdAt: Value(createdAt),
  );
}

extension SessionWithDetailsMapper on SessionWithDetails {
  SessionHistory toDomain() => SessionHistory(
    id: session.id,
    game: game.toDomain(),
    scores: scores.map((e) => e.toDomain()).toList(),
    playedAt: session.createdAt,
  );
}

extension PlayerRecordMapper on PlayerRecord {
  player_model.Player toDomain() => player_model.Player(
    id: id,
    name: name,
    createdAt: createdAt ?? DateTime.now(),
  );
}

extension PlayerMapper on player_model.Player {
  PlayersCompanion toCompanion() => PlayersCompanion(
    id: Value(id),
    name: Value(name),
    createdAt: Value(createdAt),
  );
}

extension ScoreWithPlayerMapper on ScoreWithPlayer {
  player_score_model.PlayerScore toDomain() => player_score_model.PlayerScore(
    id: id,
    sessionId: sessionId,
    name: player.name,
    score: score,
  );
}
