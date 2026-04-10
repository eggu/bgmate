import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score_tracker_notifier.freezed.dart';
part 'score_tracker_notifier.g.dart';

@riverpod
class ScoreTrackerNotifier extends _$ScoreTrackerNotifier {
  @override
  ScoreTrackerState build(int bggId, List<String> playerNames) {
    final players = playerNames.map((name) => PlayerScore(name: name)).toList();
    _loadGame(bggId);
    return ScoreTrackerState(bggId: bggId, players: players);
  }

  Future<void> _loadGame(int bggId) async {
    final repo = ref.read(gameRepositoryProvider);
    final game = await repo.getGame(bggId); // Day 2에서 구현한 메서드
    state = state.copyWith(game: AsyncValue.data(game));
  }

  void setScore(String playerName, int score) {
    final updated = state.players.map((p) {
      return p.name == playerName ? p.copyWith(score: score) : p;
    }).toList();

    state = state.copyWith(players: _recalculateRanks(updated));
  }

  /// 순위 재계산 — 점수 내림차순, 동점은 같은 순위
  List<PlayerScore> _recalculateRanks(List<PlayerScore> players) {
    final sorted = [...players]..sort((a, b) => b.score.compareTo(a.score));

    int rank = 1;
    for (int i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i].score < sorted[i - 1].score) {
        rank = i + 1;
      }
      sorted[i] = sorted[i].copyWith(rank: rank);
    }

    // 원본 순서(입력 순)로 되돌려서 반환 — UI 카드 순서 유지
    return players.map((p) {
      return sorted.firstWhere((s) => s.name == p.name);
    }).toList();
  }

  Future<void> finishSession() async {
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(sessionRepositoryProvider);
      await repo.saveSession(state.bggId, state.players);
      state = state.copyWith(isSaving: false, isSaved: true);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }
}

@freezed
sealed class ScoreTrackerState with _$ScoreTrackerState {
  const factory ScoreTrackerState({
    required int bggId,
    @Default(AsyncValue.loading()) AsyncValue<BoardGame?> game,
    @Default([]) List<PlayerScore> players,
    @Default(false) bool isSaving,
    @Default(false) bool isSaved,
  }) = _ScoreTrackerState;

  const ScoreTrackerState._();

  List<PlayerScore> get rankedPlayers =>
      [...players]..sort((a, b) => b.score.compareTo(a.score));
}
