// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $BoardGamesTable get boardGames => attachedDatabase.boardGames;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $PlayersTable get players => attachedDatabase.players;
  $PlayerScoresTable get playerScores => attachedDatabase.playerScores;
  SessionDaoManager get managers => SessionDaoManager(this);
}

class SessionDaoManager {
  final _$SessionDaoMixin _db;
  SessionDaoManager(this._db);
  $$BoardGamesTableTableManager get boardGames =>
      $$BoardGamesTableTableManager(_db.attachedDatabase, _db.boardGames);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db.attachedDatabase, _db.players);
  $$PlayerScoresTableTableManager get playerScores =>
      $$PlayerScoresTableTableManager(_db.attachedDatabase, _db.playerScores);
}
