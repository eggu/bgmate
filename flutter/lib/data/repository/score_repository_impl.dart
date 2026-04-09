import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/game_dao.dart';
import 'package:bgmate_flutter/data/local/record_mapper.dart';
import 'package:bgmate_flutter/data/local/session_dao.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/domain/repository/score_repository.dart';
import 'package:drift/drift.dart';

class ScoreRepositoryImpl implements ScoreRepository {
  final SessionDao _sessionDao;

  ScoreRepositoryImpl(this._sessionDao);

  @override
  Future<void> saveSession(BoardGame game, List<(Player, int)> scores) async {
    final session = SessionsCompanion(bggId: Value(game.bggId));
    final scoresWithPlayers = scores
        .map((e) => (e.$1.toCompanion(), e.$2))
        .toList();

    return await _sessionDao.insertSessionWithPlayers(
      session,
      scoresWithPlayers,
    );
  }

  @override
  Stream<List<SessionHistory>> watchSessions() {
    return _sessionDao.watchSessions().map(
      (sessions) => sessions.map((e) => e.toDomain()).toList(),
    );
  }

  @override
  Future<SessionHistory> getSession(int id) async {
    return (await _sessionDao.getSessionWithScores(id)).toDomain();
  }

  @override
  Future<void> deleteSession(int id) {
    return _sessionDao.deleteSession(id);
  }
}
