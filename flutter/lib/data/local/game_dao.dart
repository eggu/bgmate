import 'package:drift/drift.dart';

import 'app_database.dart';
import 'game_table.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [GameTable])
class GameDao extends DatabaseAccessor<AppDatabase> with _$GameDaoMixin {
  GameDao(super.db);

  Stream<List<GameTableData>> watchAll() => select(gameTable).watch();

  Future<List<GameTableData>> getAll() => select(gameTable).get();

  Future<void> upsert(GameTableCompanion entry) =>
      into(gameTable).insertOnConflictUpdate(entry);

  Future<void> deleteByBggId(int bggId) =>
      (delete(gameTable)..where((t) => t.bggId.equals(bggId))).go();
}
