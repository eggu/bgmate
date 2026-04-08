import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'game_dao.dart';
import 'game_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [GameTable], daos: [GameDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.addColumn(gameTable, gameTable.yearPublished);

        await customStatement(
          'UPDATE ${gameTable.actualTableName} '
          'SET ${gameTable.yearPublished.$name} = 0 '
          'WHERE ${gameTable.yearPublished.$name} IS NULL',
        );
      }

      if (from < 4) {
        await m.addColumn(gameTable, gameTable.createdAt);

        await customStatement(
          'UPDATE ${gameTable.actualTableName} '
          'SET ${gameTable.createdAt.$name} = '
          "CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER) "
          'WHERE ${gameTable.createdAt.$name} IS NULL',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement(
        'UPDATE ${gameTable.actualTableName} '
        'SET ${gameTable.createdAt.$name} = '
        "CAST(strftime('%s', ${gameTable.createdAt.$name}) AS INTEGER) "
        "WHERE typeof(${gameTable.createdAt.$name}) = 'text'",
      );

      await customStatement(
        'UPDATE ${gameTable.actualTableName} '
        'SET ${gameTable.createdAt.$name} = '
        "CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER) "
        'WHERE ${gameTable.createdAt.$name} IS NULL',
      );
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'bgmate.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
