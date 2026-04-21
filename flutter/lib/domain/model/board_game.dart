import 'package:bgmate_flutter/domain/model/collection_status.dart';
import 'package:bgmate_flutter/domain/model/game_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game.freezed.dart';

@freezed
sealed class BoardGame with _$BoardGame {
  const factory BoardGame({
    required int bggId,
    required String name,
    required int yearPublished,
    @Default('') String thumbnail,
    @Default(0) int minPlayers,
    @Default(0) int maxPlayers,
    @Default(0) int playingTime,
    @Default('') String description,
    @Default({CollectionStatus.owned}) Set<CollectionStatus> statuses,
    @Default(GameSource.manualSearch) GameSource source,
    @Default('') String notes,
    int? userRating,
  }) = _BoardGame;
}
