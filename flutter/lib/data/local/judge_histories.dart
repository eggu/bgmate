import 'package:drift/drift.dart';

@DataClassName('JudgeHistoryRecord')
class JudgeHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gameName => text()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  IntColumn get askedAt => integer()(); // Unix timestamp ms
}
