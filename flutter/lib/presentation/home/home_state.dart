import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:bgmate_flutter/presentation/sale/sale_recommend_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final List<BoardGame> recentGames;
  final List<SaleCandidate> salePreview;
  final Map<int, SessionHistory> latestSessionByBggId;

  const HomeState({
    required this.recentGames,
    required this.salePreview,
    required this.latestSessionByBggId,
  });

  factory HomeState.from({
    required List<BoardGame> games,
    required List<SaleCandidate> saleCandidates,
    required List<SessionHistory> sessions,
  }) {
    final latestSessionByBggId = _latestSessionsByBggId(sessions);
    final recentGames = _sortGamesByLatestPlay(games, latestSessionByBggId);

    return HomeState(
      recentGames: recentGames.take(3).toList(),
      salePreview: saleCandidates.take(3).toList(),
      latestSessionByBggId: latestSessionByBggId,
    );
  }

  bool get hasCollection => recentGames.isNotEmpty;
}

final homeStateProvider = FutureProvider.autoDispose<HomeState>((ref) async {
  final games = await ref.watch(gameListProvider.future);
  final saleCandidates = await ref.watch(saleCandidatesProvider.future);
  final sessions = await ref.watch(sessionHistoryProvider.future);

  return HomeState.from(
    games: games,
    saleCandidates: saleCandidates,
    sessions: sessions,
  );
});

List<BoardGame> _sortGamesByLatestPlay(
  List<BoardGame> games,
  Map<int, SessionHistory> latestSessionByBggId,
) {
  final originalIndex = {
    for (var i = 0; i < games.length; i++) games[i].bggId: i,
  };

  return [...games]..sort((a, b) {
    final aPlayedAt = latestSessionByBggId[a.bggId]?.playedAt;
    final bPlayedAt = latestSessionByBggId[b.bggId]?.playedAt;

    if (aPlayedAt != null && bPlayedAt != null) {
      final dateCompare = bPlayedAt.compareTo(aPlayedAt);
      if (dateCompare != 0) return dateCompare;
    } else if (aPlayedAt != null) {
      return -1;
    } else if (bPlayedAt != null) {
      return 1;
    }

    return originalIndex[a.bggId]!.compareTo(originalIndex[b.bggId]!);
  });
}

Map<int, SessionHistory> _latestSessionsByBggId(List<SessionHistory> sessions) {
  final latestSessionByBggId = <int, SessionHistory>{};

  for (final session in sessions) {
    final bggId = session.game.bggId;
    final current = latestSessionByBggId[bggId];
    if (current == null || session.playedAt.isAfter(current.playedAt)) {
      latestSessionByBggId[bggId] = session;
    }
  }

  return latestSessionByBggId;
}
