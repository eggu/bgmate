// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dao.dart';

// ignore_for_file: type=lint
mixin _$GameDaoMixin on DatabaseAccessor<AppDatabase> {
  $BoardGamesTable get boardGames => attachedDatabase.boardGames;
  GameDaoManager get managers => GameDaoManager(this);
}

class GameDaoManager {
  final _$GameDaoMixin _db;
  GameDaoManager(this._db);
  $$BoardGamesTableTableManager get boardGames =>
      $$BoardGamesTableTableManager(_db.attachedDatabase, _db.boardGames);
}
