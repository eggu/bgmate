import 'package:bgmate_flutter/data/local/sessions.dart';
import 'package:bgmate_flutter/data/local/players.dart';
import 'package:drift/drift.dart';

@DataClassName('PlayerScoreRecord')
class PlayerScores extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().customConstraint(
        'REFERENCES sessions(id) ON DELETE CASCADE',
      )();

  IntColumn get playerId =>
      integer().customConstraint(
        'REFERENCES players(id) ON DELETE CASCADE',
      )();

  IntColumn get score => integer().withDefault(const Constant(0))();
}
