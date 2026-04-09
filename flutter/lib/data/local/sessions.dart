import 'package:bgmate_flutter/data/local/board_games.dart';
import 'package:drift/drift.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bggId => integer().references(BoardGames, #bggId)();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
