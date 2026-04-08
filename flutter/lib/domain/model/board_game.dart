import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game.freezed.dart';

@freezed
sealed class BoardGame with _$BoardGame {
  const factory BoardGame({
    required int bggId,
    required String name,
    @Default('') String thumbnail,
    @Default(0) int minPlayers,
    @Default(0) int maxPlayers,
    @Default(0) int playingTime,
    @Default('') String description,
    @Default(false) bool isInCollection,
    @Default(0) int? yearPublished,
  }) = _BoardGame;
}
