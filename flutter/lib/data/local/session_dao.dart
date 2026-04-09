import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/player_scores.dart';
import 'package:bgmate_flutter/data/local/players.dart';
import 'package:bgmate_flutter/data/local/session_with_details.dart';
import 'package:bgmate_flutter/data/local/sessions.dart';
import 'package:drift/drift.dart';

import 'board_games.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions, Players, PlayerScores, BoardGames])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<int> insertSession(SessionsCompanion entity) =>
      into(sessions).insert(entity);

  Future<void> insertPlayerIfNotExists(PlayersCompanion entity) =>
      into(players).insert(entity, mode: InsertMode.insertOrIgnore);

  Future<void> insertPlayerScore(PlayerScoresCompanion entity) =>
      into(playerScores).insert(entity, mode: InsertMode.insertOrReplace);

  Future<void> deleteSession(int sessionId) async {
    await (delete(sessions)..where((t) => t.id.equals(sessionId))).go();
  }

  Future<void> insertSessionWithPlayers(
    SessionsCompanion session,
    List<(PlayersCompanion, int)> scores,
  ) async {
    await transaction(() async {
      final sessionId = await insertSession(session);

      for (var i = 0; i < scores.length; i++) {
        final player = scores[i].$1;
        final score = scores[i].$2;

        await insertPlayerIfNotExists(player);
        final playerId = (await getPlayerByName(player.name.value)).id;

        await insertPlayerScore(
          PlayerScoresCompanion(
            sessionId: Value(sessionId),
            playerId: Value(playerId),
            score: Value(score),
          ),
        );
      }
    });
  }

  Future<PlayerRecord> getPlayerByName(String name) =>
      (select(players)..where((t) => t.name.equals(name))).getSingle();

  Future<SessionWithDetails> getSessionWithScores(int sessionId) async {
    final rows =
        await ((select(sessions)..where((t) => t.id.equals(sessionId)))
              ..orderBy([
                (t) => OrderingTerm.desc(playerScores.score),
                (t) => OrderingTerm.asc(playerScores.id),
              ]))
            .join([
              leftOuterJoin(
                playerScores,
                playerScores.sessionId.equalsExp(sessions.id),
              ),
              leftOuterJoin(
                players,
                players.id.equalsExp(playerScores.playerId),
              ),
            ])
            .get();

    final session = rows.first.readTable(sessions);
    final scores = <ScoreWithPlayer>[];
    final game = await (select(
      boardGames,
    )..where((t) => t.bggId.equals(session.bggId))).getSingle();

    for (final row in rows) {
      final playerScore = row.readTableOrNull(playerScores);
      final player = row.readTableOrNull(players);

      if (playerScore != null && player != null) {
        scores.add(
          ScoreWithPlayer(
            score: playerScore.score,
            player: player,
            id: playerScore.id,
            sessionId: playerScore.sessionId,
          ),
        );
      }
    }

    return SessionWithDetails(session: session, scores: scores, game: game);
  }

  Stream<List<SessionWithDetails>> watchSessions() {
    final query =
        (select(sessions)..orderBy([
              (t) => OrderingTerm.desc(t.createdAt),
              (t) => OrderingTerm.desc(t.id),
            ]))
            .join([
              leftOuterJoin(
                playerScores,
                playerScores.sessionId.equalsExp(sessions.id),
              ),
              leftOuterJoin(
                players,
                players.id.equalsExp(playerScores.playerId),
              ),
              leftOuterJoin(
                boardGames,
                boardGames.bggId.equalsExp(sessions.bggId),
              ),
            ]);

    return query.watch().map((rows) {
      final grouped = <int, SessionWithDetails>{};

      for (final row in rows) {
        final session = row.readTable(sessions);
        final playerScore = row.readTableOrNull(playerScores);
        final player = row.readTableOrNull(players);
        final game = row.readTable(boardGames);

        final entry = grouped.putIfAbsent(
          session.id,
          () => SessionWithDetails(session: session, scores: [], game: game),
        );

        if (playerScore != null && player != null) {
          entry.scores.add(
            ScoreWithPlayer(
              score: playerScore.score,
              player: player,
              id: playerScore.id,
              sessionId: session.id,
            ),
          );
        }
      }

      return grouped.values.toList();
    });
  }
}
