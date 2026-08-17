import 'package:drift/drift.dart';

import 'app_database.dart';
import 'board_games.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [BoardGames])
class GameDao extends DatabaseAccessor<AppDatabase> with _$GameDaoMixin {
  GameDao(super.db);

  Stream<List<BoardGameRecord>> watchAll() =>
      (select(boardGames)..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.asc(t.bggId),
          ]))
          .watch();

  Future<List<BoardGameRecord>> getAll() =>
      (select(boardGames)..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.asc(t.bggId),
          ]))
          .get();

  Future<void> upsert(BoardGamesCompanion entry) =>
      into(boardGames).insertOnConflictUpdate(entry);

  Future<void> deleteByBggId(int bggId) =>
      (delete(boardGames)..where((t) => t.bggId.equals(bggId))).go();

  Future<BoardGameRecord?> getGame(int id) async {
    return (select(
      boardGames,
    )..where((t) => t.bggId.equals(id))).getSingleOrNull();
  }
}
