import '../model/player_score.dart';
import '../model/session_history.dart';

abstract interface class SessionRepository {
  Future<int> saveSession(int bggId, List<PlayerScore> scores);

  Stream<List<SessionHistory>> watchSessions();

  Future<SessionHistory> getSession(int id);

  Future<void> deleteSession(int id);
}
