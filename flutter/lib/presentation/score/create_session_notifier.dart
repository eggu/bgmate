import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'create_session_state.dart';

part 'create_session_notifier.g.dart';

@riverpod
class CreateSessionNotifier extends _$CreateSessionNotifier {
  @override
  CreateSessionState build(int bggId) {
    // bggId로 게임 정보를 즉시 로드
    _loadGame(bggId);
    return const CreateSessionState();
  }

  Future<void> _loadGame(int bggId) async {
    final repo = ref.read(gameRepositoryProvider);
    final game = await repo.getGame(bggId); // Day 2에서 구현한 메서드
    state = state.copyWith(game: AsyncValue.data(game));
  }

  void addPlayer(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (state.playerNames.contains(trimmed)) return; // 중복 방지
    state = state.copyWith(playerNames: [...state.playerNames, trimmed]);
  }

  void removePlayer(int index) {
    final updated = [...state.playerNames]..removeAt(index);
    state = state.copyWith(playerNames: updated);
  }

  Future<void> confirmSession() async {
    if (!state.canStart) return;
    final game = state.game.value;
    if (game == null) return;
  }
}
