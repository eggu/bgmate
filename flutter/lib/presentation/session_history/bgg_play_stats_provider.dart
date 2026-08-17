import 'package:bgmate_flutter/data/local/game_table_mapper.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/game_play_stats.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BggPlayStatsEntry {
  final BoardGame game;
  final int playCount;
  final DateTime? lastPlayedAt;
  final double? rating;
  final bool isExpansion;

  const BggPlayStatsEntry({
    required this.game,
    required this.playCount,
    required this.lastPlayedAt,
    required this.rating,
    this.isExpansion = false,
  });
}

final bggPlayStatsProvider =
    FutureProvider.autoDispose<List<BggPlayStatsEntry>>((ref) async {
      final games = await ref.watch(gameDaoProvider).getAll();
      final stats = await ref.watch(gamePlayStatsDaoProvider).getAll();
      return buildBggPlayStatsEntries(
        games: games.map((g) => g.toDomain()),
        stats: stats.map(
          (s) => GamePlayStats(
            bggId: s.bggId,
            playCount: s.bggPlayCount,
            lastPlayedAt: s.bggLastPlayedAt,
            rating: s.bggRating,
            isExpansion: s.bggIsExpansion,
          ),
        ),
      );
    });

List<BggPlayStatsEntry> buildBggPlayStatsEntries({
  required Iterable<BoardGame> games,
  required Iterable<GamePlayStats> stats,
}) {
  final gamesById = {for (final game in games) game.bggId: game};
  final entries = <BggPlayStatsEntry>[];

  for (final item in stats) {
    if (item.playCount <= 0) continue;
    final game = gamesById[item.bggId];
    if (game == null) continue;
    entries.add(
      BggPlayStatsEntry(
        game: game,
        playCount: item.playCount,
        lastPlayedAt: item.lastPlayedAt,
        rating: item.rating,
        isExpansion: item.isExpansion,
      ),
    );
  }

  entries.sort((a, b) {
    final aDate = a.lastPlayedAt;
    final bDate = b.lastPlayedAt;
    if (aDate == null && bDate == null) {
      return b.playCount.compareTo(a.playCount);
    }
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });
  return entries;
}

String bggPlayStatsDetailLocation(BggPlayStatsEntry entry) =>
    AppRoutes.bggPlayStatsDetailLocation(entry.game.bggId);
