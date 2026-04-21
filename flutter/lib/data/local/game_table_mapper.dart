import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/collection_status.dart';
import 'package:bgmate_flutter/domain/model/game_source.dart';
import 'package:drift/drift.dart';

extension BoardGameRecordMapper on BoardGameRecord {
  BoardGame toDomain() => BoardGame(
    bggId: bggId,
    name: name,
    thumbnail: thumbnail,
    minPlayers: minPlayers,
    maxPlayers: maxPlayers,
    playingTime: playingTime,
    description: description,
    yearPublished: yearPublished,
    statuses: statuses.toCollectionStatusSet(),
    source: GameSource.fromJson(source),
    notes: notes,
    userRating: userRating,
  );
}

extension BoardGameMapper on BoardGame {
  BoardGamesCompanion toCompanion() => BoardGamesCompanion(
    bggId: Value(bggId),
    name: Value(name),
    yearPublished: Value(yearPublished),
    thumbnail: Value(thumbnail),
    minPlayers: Value(minPlayers),
    maxPlayers: Value(maxPlayers),
    playingTime: Value(playingTime),
    description: Value(description),
    statuses: Value(statuses.serialize()),
    source: Value(source.toJson()),
    notes: Value(notes),
    userRating: Value(userRating),
  );
}
