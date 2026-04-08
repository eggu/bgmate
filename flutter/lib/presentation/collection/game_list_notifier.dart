import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/board_game.dart';

part 'game_list_notifier.g.dart';

@riverpod
class GameListNotifier extends _$GameListNotifier {
  @override
  Future<List<BoardGame>> build() async {
    final repository = ref.watch(gameRepositoryProvider);
    return repository.getCollection();
  }

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
