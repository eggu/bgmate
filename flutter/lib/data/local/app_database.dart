import 'dart:io';

import 'package:bgmate_flutter/data/local/board_games.dart';
import 'package:bgmate_flutter/data/local/judge_histories.dart';
import 'package:bgmate_flutter/data/local/judge_history_dao.dart';
import 'package:bgmate_flutter/data/local/player_scores.dart';
import 'package:bgmate_flutter/data/local/players.dart';
import 'package:bgmate_flutter/data/local/sessions.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'game_dao.dart';
import 'session_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [BoardGames, Players, Sessions, PlayerScores, JudgeHistories],
  daos: [GameDao, SessionDao, JudgeHistoryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(playerScores, playerScores.rank);
        await customStatement('''
          UPDATE player_scores
          SET rank = (
            SELECT COUNT(*) + 1
            FROM player_scores ps2
            WHERE ps2.session_id = player_scores.session_id
              AND ps2.score > player_scores.score
          )
        ''');
      }
      if (from < 3) {
        await m.createTable(judgeHistories);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        "SET ${boardGames.name.$name} = '' "
        'WHERE ${boardGames.name.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        'SET ${boardGames.yearPublished.$name} = 0 '
        'WHERE ${boardGames.yearPublished.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        "SET ${boardGames.thumbnail.$name} = '' "
        'WHERE ${boardGames.thumbnail.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        'SET ${boardGames.minPlayers.$name} = 0 '
        'WHERE ${boardGames.minPlayers.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        'SET ${boardGames.maxPlayers.$name} = 0 '
        'WHERE ${boardGames.maxPlayers.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        'SET ${boardGames.playingTime.$name} = 0 '
        'WHERE ${boardGames.playingTime.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        "SET ${boardGames.description.$name} = '' "
        'WHERE ${boardGames.description.$name} IS NULL',
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        'SET ${boardGames.createdAt.$name} = '
        "CAST(strftime('%s', ${boardGames.createdAt.$name}) AS INTEGER) "
        "WHERE typeof(${boardGames.createdAt.$name}) = 'text'",
      );

      await customStatement(
        'UPDATE ${boardGames.actualTableName} '
        'SET ${boardGames.createdAt.$name} = '
        "CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER) "
        'WHERE ${boardGames.createdAt.$name} IS NULL',
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
