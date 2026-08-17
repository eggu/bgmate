import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/domain/model/game_play_stats.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaleFiltersNotifier extends Notifier<SaleFilters> {
  @override
  SaleFilters build() => const SaleFilters();

  void set(SaleFilters filters) => state = filters;
}

final saleFiltersProvider = NotifierProvider<SaleFiltersNotifier, SaleFilters>(
  SaleFiltersNotifier.new,
);

final saleCandidatesProvider = FutureProvider.autoDispose<List<SaleCandidate>>((
  ref,
) async {
  final filters = ref.watch(saleFiltersProvider);
  final games = await ref.watch(gameListProvider.future);
  final records = await ref.watch(gamePlayStatsDaoProvider).getAll();
  final sessions = await ref.watch(sessionHistoryProvider.future);
  final stats = mergeGamePlayStats(
    syncedStats: records.map(
      (r) => GamePlayStats(
        bggId: r.bggId,
        playCount: r.bggPlayCount,
        lastPlayedAt: r.bggLastPlayedAt,
        rating: r.bggRating,
        isExpansion: r.bggIsExpansion,
      ),
    ),
    localSessions: sessions,
  );

  return selectSaleCandidates(
    games: games,
    statsByBggId: stats,
    now: DateTime.now(),
    filters: filters,
  );
});
