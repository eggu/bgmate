import 'dart:math';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/board_game.dart';

part 'game_list_notifier.g.dart';

@riverpod
class GameListNotifier extends _$GameListNotifier {
  @override
  Future<List<BoardGame>> build() async {
    final repository = ref.watch(gameRepositoryProvider);

    final sub = repository.watchGames().listen((games) {
      state = AsyncData(games);
    });
    ref.onDispose(sub.cancel);

    final initialGames = await repository.watchGames().first;

    // 정보가 없는 게임을 백그라운드에서 갱신 — stream이 자동으로 UI 업데이트
    _enrichStaleGames(initialGames);

    return initialGames;
  }

  /// thumbnail이 비어 있는 게임을 20개씩 /thing API로 갱신 후 DB에 저장
  Future<void> _enrichStaleGames(List<BoardGame> games) async {
    final stale = games.where(_needsEnrichment).toList();
    if (stale.isEmpty) return;

    final repo = ref.read(gameRepositoryProvider);
    for (var i = 0; i < stale.length; i += 20) {
      final batch = stale.sublist(i, min(i + 20, stale.length));
      try {
        final enriched = await repo.enrichWithDetails(batch);
        for (final game in enriched) {
          await repo.addToCollection(game.copyWith(isInCollection: true));
        }
      } catch (_) {
        // 배치 실패 시 다음 배치 계속 진행
      }
    }
  }

  /// BGG에 썸네일이 없는 게임도 있으므로 thumbnail만으로 판단하지 않음.
  /// minPlayers == 0 && maxPlayers == 0 이면 미갱신으로 간주.
  bool _needsEnrichment(BoardGame game) =>
      game.minPlayers == 0 && game.maxPlayers == 0;

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => ref.read(gameRepositoryProvider).getCollection(),
    );
  }

  Future<void> addGame(BoardGame game) async {
    await ref.read(gameRepositoryProvider).addToCollection(game);
    ref.invalidateSelf();
  }

  Future<void> removeGame(BoardGame game) async {
    await ref.read(gameRepositoryProvider).removeFromCollection(game);
    ref.invalidateSelf();
  }
}
