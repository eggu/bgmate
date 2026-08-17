import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommend_notifier.g.dart';

@riverpod
class RecommendNotifier extends AsyncNotifier<List<RecommendResult>> {
  @override
  FutureOr<List<RecommendResult>> build() {
    return [];
  }

  Future<void> recommend(
    int playerCount,
    PlayTime playTime,
    Set<Mood> moods,
    bool includeNew,
  ) async {
    state = const AsyncLoading();
    final condition = RecommendCondition(
      playerCount: playerCount,
      playTimeMinutes: playTime,
      moods: moods,
    );

    try {
      final result = await ref
          .read(recommendRepositoryProvider)
          .recommend(
            condition: condition,
            includeNew: includeNew,
            ownedGames: [],
          );
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
