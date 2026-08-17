// ignore: unused_import
import 'package:bgmate_flutter/data/local/board_games.dart';
import 'package:drift/drift.dart';

@DataClassName('SessionRecord')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bggId => integer().customConstraint(
    'REFERENCES game_table(bgg_id) ON DELETE CASCADE',
  )();

  IntColumn get bggPlayId => integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
