import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/game_play_stats_table.dart';
import 'package:drift/drift.dart';

part 'game_play_stats_dao.g.dart';

@DriftAccessor(tables: [GamePlayStatsTable])
class GamePlayStatsDao extends DatabaseAccessor<AppDatabase>
    with _$GamePlayStatsDaoMixin {
  GamePlayStatsDao(super.db);

  Stream<List<GamePlayStatsRecord>> watchAll() =>
      select(gamePlayStatsTable).watch();

  Future<List<GamePlayStatsRecord>> getAll() =>
      select(gamePlayStatsTable).get();

  Future<void> upsertAll(Iterable<GamePlayStatsTableCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(gamePlayStatsTable, entries.toList());
    });
  }

  Future<void> deleteAll() => delete(gamePlayStatsTable).go();
}
