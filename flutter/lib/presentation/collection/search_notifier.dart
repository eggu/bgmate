import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends AsyncNotifier<List<BoardGame>> {
  @override
  Future<List<BoardGame>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).searchBgg(trimmed),
    );
  }

  void clear() {
    state = const AsyncData([]);
  }
}

final searchNotifierProvider =
    AsyncNotifierProvider.autoDispose<SearchNotifier, List<BoardGame>>(
      SearchNotifier.new,
    );
