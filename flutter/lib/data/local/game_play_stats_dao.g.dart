// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_play_stats_dao.dart';

// ignore_for_file: type=lint
mixin _$GamePlayStatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BoardGamesTable get boardGames => attachedDatabase.boardGames;
  $GamePlayStatsTableTable get gamePlayStatsTable =>
      attachedDatabase.gamePlayStatsTable;
  GamePlayStatsDaoManager get managers => GamePlayStatsDaoManager(this);
}

class GamePlayStatsDaoManager {
  final _$GamePlayStatsDaoMixin _db;
  GamePlayStatsDaoManager(this._db);
  $$BoardGamesTableTableManager get boardGames =>
      $$BoardGamesTableTableManager(_db.attachedDatabase, _db.boardGames);
  $$GamePlayStatsTableTableTableManager get gamePlayStatsTable =>
      $$GamePlayStatsTableTableTableManager(
        _db.attachedDatabase,
        _db.gamePlayStatsTable,
      );
}
