import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:drift/drift.dart';

extension GameTableDataMapper on GameTableData {
  BoardGame toDomain() => BoardGame(
    bggId: bggId,
    name: name,
    thumbnail: thumbnail,
    minPlayers: minPlayers,
    maxPlayers: maxPlayers,
    playingTime: playingTime,
    description: description,
    yearPublished: yearPublished,
    isInCollection: true,
  );
}

extension BoardGameMapper on BoardGame {
  GameTableCompanion toCompanion() => GameTableCompanion(
    bggId: Value(bggId),
    name: Value(name),
    yearPublished: Value(yearPublished),
    thumbnail: Value(thumbnail),
    minPlayers: Value(minPlayers),
    maxPlayers: Value(maxPlayers),
    playingTime: Value(playingTime),
    description: Value(description),
  );
}
