import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';

@freezed
sealed class Player with _$Player {
  const factory Player({
    required int id,
    required String name,
    required DateTime createdAt,
  }) = _Player;
}
