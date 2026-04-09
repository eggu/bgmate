import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player.dart';

import '../model/session_history.dart';

abstract interface class ScoreRepository {
  Future<void> saveSession(BoardGame game, List<(Player, int)> scores);

  Stream<List<SessionHistory>> watchSessions();

  Future<SessionHistory> getSession(int id);

  Future<void> deleteSession(int id);
}
