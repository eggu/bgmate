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

  Future<int> insertSessionWithPlayers(
    SessionsCompanion session,
    List<(PlayersCompanion, int, int)> scores, // (player, score, rank)
  ) async {
    return await transaction(() async {
      final sessionId = await insertSession(session);

      for (var i = 0; i < scores.length; i++) {
        final player = scores[i].$1;
        final score = scores[i].$2;
        final rank = scores[i].$3;

        await insertPlayerIfNotExists(player);
        final playerId = (await getPlayerByName(player.name.value)).id;

        await insertPlayerScore(
          PlayerScoresCompanion(
            sessionId: Value(sessionId),
            playerId: Value(playerId),
            score: Value(score),
            rank: Value(rank),
          ),
        );
      }

      return sessionId;
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
            rank: playerScore.rank,
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
      final sessionRecords =
          <int, ({SessionRecord session, BoardGameRecord game})>{};
      final scoresBySession = <int, List<ScoreWithPlayer>>{};

      for (final row in rows) {
        final session = row.readTable(sessions);
        final playerScore = row.readTableOrNull(playerScores);
        final player = row.readTableOrNull(players);
        final game = row.readTable(boardGames);

        sessionRecords.putIfAbsent(
          session.id,
          () => (session: session, game: game),
        );
        final scoreList = scoresBySession.putIfAbsent(session.id, () => []);

        if (playerScore != null && player != null) {
          scoreList.add(
            ScoreWithPlayer(
              score: playerScore.score,
              player: player,
              id: playerScore.id,
              sessionId: session.id,
              rank: playerScore.rank
            ),
          );
        }
      }

      return sessionRecords.entries.map((e) {
        final record = e.value;
        return SessionWithDetails(
          session: record.session,
          game: record.game,
          scores: scoresBySession[e.key] ?? [],
        );
      }).toList();
    });
  }
}
