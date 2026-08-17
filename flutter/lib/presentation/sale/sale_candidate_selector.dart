import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/game_play_stats.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';

enum SaleGameTypeFilter { base, expansion, all }

class SaleFilters {
  final int monthsUnplayed;
  final int minPlays;
  final int maxCandidates;
  final SaleGameTypeFilter gameType;

  const SaleFilters({
    this.monthsUnplayed = 24,
    this.minPlays = 1,
    this.maxCandidates = 30,
    this.gameType = SaleGameTypeFilter.base,
  });

  SaleFilters copyWith({
    int? monthsUnplayed,
    int? minPlays,
    int? maxCandidates,
    SaleGameTypeFilter? gameType,
  }) {
    return SaleFilters(
      monthsUnplayed: monthsUnplayed ?? this.monthsUnplayed,
      minPlays: minPlays ?? this.minPlays,
      maxCandidates: maxCandidates ?? this.maxCandidates,
      gameType: gameType ?? this.gameType,
    );
  }
}

class SaleCandidate {
  final BoardGame game;
  final int playCount;
  final DateTime? lastPlayedAt;
  final double? rating;
  final double score;
  final double? yearsUnplayed;

  const SaleCandidate({
    required this.game,
    required this.playCount,
    required this.lastPlayedAt,
    required this.rating,
    required this.score,
    required this.yearsUnplayed,
  });
}

List<SaleCandidate> selectSaleCandidates({
  required List<BoardGame> games,
  required Map<int, GamePlayStats> statsByBggId,
  required DateTime now,
  SaleFilters filters = const SaleFilters(),
}) {
  final candidates = <SaleCandidate>[];

  for (final game in games) {
    final stats = statsByBggId[game.bggId];
    final playCount = stats?.playCount ?? 0;
    final isExpansion = stats?.isExpansion ?? false;
    if (!_matchesGameType(isExpansion, filters.gameType)) continue;
    if (playCount < filters.minPlays) continue;

    final lastPlayedAt = stats?.lastPlayedAt;
    final yearsUnplayed = lastPlayedAt == null
        ? null
        : now.difference(lastPlayedAt).inDays / 365.25;
    final score = _score(
      playCount: playCount,
      yearsUnplayed: yearsUnplayed,
      thresholdMonths: filters.monthsUnplayed,
    );

    if (score <= 0) continue;
    candidates.add(
      SaleCandidate(
        game: game,
        playCount: playCount,
        lastPlayedAt: lastPlayedAt,
        rating: stats?.rating,
        score: score,
        yearsUnplayed: yearsUnplayed,
      ),
    );
  }

  candidates.sort((a, b) => b.score.compareTo(a.score));
  return candidates.take(filters.maxCandidates).toList();
}

Map<int, GamePlayStats> mergeGamePlayStats({
  required Iterable<GamePlayStats> syncedStats,
  required Iterable<SessionHistory> localSessions,
}) {
  final merged = {for (final stats in syncedStats) stats.bggId: stats};
  final local = <int, ({int count, DateTime lastPlayedAt})>{};

  for (final session in localSessions) {
    final bggId = session.game.bggId;
    final prev = local[bggId];
    local[bggId] = (
      count: (prev?.count ?? 0) + 1,
      lastPlayedAt: _latest(prev?.lastPlayedAt, session.playedAt)!,
    );
  }

  for (final entry in local.entries) {
    final existing = merged[entry.key];
    merged[entry.key] = GamePlayStats(
      bggId: entry.key,
      playCount: existing == null
          ? entry.value.count
          : _max(existing.playCount, entry.value.count),
      lastPlayedAt: _latest(existing?.lastPlayedAt, entry.value.lastPlayedAt),
      rating: existing?.rating,
      isExpansion: existing?.isExpansion ?? false,
    );
  }

  return merged;
}

double _score({
  required int playCount,
  required double? yearsUnplayed,
  required int thresholdMonths,
}) {
  if (yearsUnplayed == null) {
    if (playCount > 0) return 0;
    return 120;
  }
  final threshold = thresholdMonths / 12;
  if (yearsUnplayed < threshold) return 0;

  final ageScore = (yearsUnplayed * 10).clamp(0, 90).toDouble();
  final playsBonus = (20 - playCount * 2).clamp(0, 20).toDouble();
  return ageScore + playsBonus;
}

DateTime? _latest(DateTime? a, DateTime? b) {
  if (a == null) return b;
  if (b == null) return a;
  return a.isAfter(b) ? a : b;
}

int _max(int a, int b) => a > b ? a : b;

bool _matchesGameType(bool isExpansion, SaleGameTypeFilter filter) {
  return switch (filter) {
    SaleGameTypeFilter.all => true,
    SaleGameTypeFilter.base => !isExpansion,
    SaleGameTypeFilter.expansion => isExpansion,
  };
}
