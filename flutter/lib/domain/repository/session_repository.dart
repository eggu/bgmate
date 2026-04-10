import '../model/session_history.dart';

abstract interface class SessionRepository {
  Future<void> saveSession(int bggId, List<(String, int)> scores);

  Stream<List<SessionHistory>> watchSessions();

  Future<SessionHistory> getSession(int id);

  Future<void> deleteSession(int id);
}
