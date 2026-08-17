import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/data/local/app_settings_dao.dart';
import 'package:bgmate_flutter/data/local/board_games.dart';
import 'package:bgmate_flutter/data/local/game_play_stats_dao.dart';
import 'package:bgmate_flutter/data/local/game_play_stats_table.dart';
import 'package:bgmate_flutter/data/local/judge_histories.dart';
import 'package:bgmate_flutter/data/local/judge_history_dao.dart';
import 'package:bgmate_flutter/data/local/player_scores.dart';
import 'package:bgmate_flutter/data/local/players.dart';
import 'package:bgmate_flutter/data/local/sessions.dart';
import 'package:drift/drift.dart';

import 'connection/native_connection.dart'
    if (dart.library.html) 'connection/web_connection.dart';

import 'game_dao.dart';
import 'session_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BoardGames,
    Players,
    Sessions,
    PlayerScores,
    JudgeHistories,
    GamePlayStatsTable,
    AppSettings,
  ],
  daos: [
    GameDao,
    SessionDao,
    JudgeHistoryDao,
    GamePlayStatsDao,
    AppSettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

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
      if (from < 4) {
        await m.createTable(gamePlayStatsTable);
      }
      if (from >= 4 && from < 5) {
        await m.addColumn(
          gamePlayStatsTable,
          gamePlayStatsTable.bggIsExpansion,
        );
      }
      if (from < 5) {
        await m.createTable(appSettings);
      }
      if (from < 6) {
        await m.addColumn(sessions, sessions.bggPlayId);
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

DatabaseConnection _openConnection() => openConnection();
