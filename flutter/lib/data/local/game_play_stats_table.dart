// ignore: unused_import
import 'package:bgmate_flutter/data/local/board_games.dart';
import 'package:drift/drift.dart';

@DataClassName('GamePlayStatsRecord')
class GamePlayStatsTable extends Table {
  IntColumn get bggId => integer().customConstraint(
    'NOT NULL REFERENCES game_table(bgg_id) ON DELETE CASCADE',
  )();

  IntColumn get bggPlayCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get bggLastPlayedAt => dateTime().nullable()();

  RealColumn get bggRating => real().nullable()();

  BoolColumn get bggIsExpansion =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime()();

  @override
  String get tableName => 'game_play_stats';

  @override
  Set<Column> get primaryKey => {bggId};
}
