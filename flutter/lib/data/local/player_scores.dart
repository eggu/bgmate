import 'package:bgmate_flutter/data/local/sessions.dart';
import 'package:bgmate_flutter/data/local/players.dart';
import 'package:drift/drift.dart';

class PlayerScores extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(Sessions, #id)();

  IntColumn get playerId => integer().references(Players, #id)();

  IntColumn get score => integer().withDefault(const Constant(0))();
}
