import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_session_state.freezed.dart';

@freezed
sealed class CreateSessionState with _$CreateSessionState {
  const factory CreateSessionState({
    @Default(AsyncValue.loading()) AsyncValue<BoardGame?> game,
    @Default([]) List<String> playerNames,
  }) = _CreateSessionState;

  const CreateSessionState._();

  bool get canStart => playerNames.length >= 2;
}