import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_detail_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_stats_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionHistoryDetailScreen extends ConsumerWidget {
  final int sessionId;

  const SessionHistoryDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(title: Text(_historyDetailTitle(historyState))),
      body: historyState.when(
        data: (SessionHistory? data) {
          if (data == null) {
            return const Center(child: Text('전적 기록을 찾을 수 없습니다'));
          }
          return _SessionHistoryDetailBody(history: data);
        },
        error: (e, _) => Center(child: Text('오류: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class BggPlayStatsDetailScreen extends ConsumerWidget {
  final int bggId;

  const BggPlayStatsDetailScreen({super.key, required this.bggId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(bggPlayStatsProvider);
    final detailState = ref.watch(bggPlayDetailProvider(bggId));

    return Scaffold(
      appBar: AppBar(title: Text(_bggPlayStatsDetailTitle(statsState, bggId))),
      body: statsState.when(
        data: (entries) {
          final entry = _findBggPlayStatsEntry(entries, bggId);
          if (entry == null) {
            return const Center(child: Text('전적 기록을 찾을 수 없습니다'));
          }
          return detailState.when(
            data: (detail) => _BggPlayDetailBody(detail: detail),
            error: (e, _) => Center(
              child: Text(
                'BGG 플레이 기록을 불러오지 못했습니다.\n$e',
                textAlign: TextAlign.center,
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (e, _) => Center(child: Text('오류: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

typedef BggPlayStatsDetailRow = ({String label, String value});

List<BggPlayStatsDetailRow> buildBggPlayStatsDetailRows(
  BggPlayStatsEntry entry,
) {
  final lastPlayedAt = entry.lastPlayedAt;
  return [
    (label: '플레이 횟수', value: '${entry.playCount}회'),
    (
      label: '마지막 플레이',
      value: lastPlayedAt == null
          ? '기록 없음'
          : _formatBggPlayStatsDate(lastPlayedAt),
    ),
  ];
}

String formatSessionDetailDate(DateTime playedAt) {
  final hour = playedAt.hour.toString().padLeft(2, '0');
  final minute = playedAt.minute.toString().padLeft(2, '0');
  return '${playedAt.year}년 ${playedAt.month}월 ${playedAt.day}일 $hour:$minute';
}

List<PlayerScore> sortSessionDetailPlayers(List<PlayerScore> players) {
  final sorted = players.toList()
    ..sort((a, b) {
      if (a.rank > 0 && b.rank > 0 && a.rank != b.rank) {
        return a.rank.compareTo(b.rank);
      }

      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;

      if (a.rank != b.rank) {
        final aRank = a.rank > 0 ? a.rank : 1 << 30;
        final bRank = b.rank > 0 ? b.rank : 1 << 30;
        return aRank.compareTo(bRank);
      }

      return a.id.compareTo(b.id);
    });
  return sorted;
}

List<BggPlayPlayer> sortBggPlayPlayers(List<BggPlayPlayer> players) {
  final sorted = players.toList()
    ..sort((a, b) {
      if (a.win != b.win) return a.win ? -1 : 1;

      final aScore = _numericBggScore(a.score);
      final bScore = _numericBggScore(b.score);
      if (aScore != null && bScore != null && aScore != bScore) {
        return bScore.compareTo(aScore);
      }
      if (aScore != null && bScore == null) return -1;
      if (aScore == null && bScore != null) return 1;

      return _bggPlayerName(a).compareTo(_bggPlayerName(b));
    });
  return sorted;
}

String _historyDetailTitle(AsyncValue<SessionHistory?> state) {
  return state.maybeWhen(
    data: (history) => history?.game.name ?? '전적 상세',
    orElse: () => '전적 상세',
  );
}

BggPlayStatsEntry? _findBggPlayStatsEntry(
  List<BggPlayStatsEntry> entries,
  int bggId,
) {
  for (final entry in entries) {
    if (entry.game.bggId == bggId) return entry;
  }
  return null;
}

String _bggPlayStatsDetailTitle(
  AsyncValue<List<BggPlayStatsEntry>> state,
  int bggId,
) {
  return state.maybeWhen(
    data: (entries) =>
        _findBggPlayStatsEntry(entries, bggId)?.game.name ?? '전적 상세',
    orElse: () => '전적 상세',
  );
}

class _SessionHistoryDetailBody extends StatelessWidget {
  final SessionHistory history;

  const _SessionHistoryDetailBody({required this.history});

  @override
  Widget build(BuildContext context) {
    final players = sortSessionDetailPlayers(history.scores);
    final themeData = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: players.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              formatSessionDetailDate(history.playedAt),
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return _PlayerScoreItemCard(playerScore: players[i - 1], position: i);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 8),
    );
  }
}

class _BggPlayDetailBody extends StatelessWidget {
  final BggPlayDetail detail;

  const _BggPlayDetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    if (detail.plays.isEmpty) {
      return const Center(child: Text('플레이 상세 기록이 없습니다'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: detail.plays.length,
      itemBuilder: (context, index) =>
          _BggPlaySessionCard(play: detail.plays[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}

class _BggPlaySessionCard extends StatelessWidget {
  final BggPlaySession play;

  const _BggPlaySessionCard({required this.play});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final players = sortBggPlayPlayers(play.players);
    final meta = _bggPlayMeta(play);
    final comments = play.comments?.trim();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatBggPlayDate(play.date),
              style: themeData.textTheme.titleMedium,
            ),
            if (meta.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                meta,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (comments != null && comments.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(comments, style: themeData.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            if (players.isEmpty)
              Text(
                '플레이어 점수 기록이 없습니다',
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              )
            else
              for (var i = 0; i < players.length; i++)
                _BggPlayerScoreRow(player: players[i], position: i + 1),
          ],
        ),
      ),
    );
  }
}

class _BggPlayerScoreRow extends StatelessWidget {
  final BggPlayPlayer player;
  final int position;

  const _BggPlayerScoreRow({required this.player, required this.position});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final score = _bggScoreText(player.score);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              player.win ? '🏆' : '$position위',
              style: themeData.textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Text(
              _bggPlayerName(player),
              style: themeData.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(score, style: themeData.textTheme.titleMedium),
        ],
      ),
    );
  }
}

String _formatBggPlayStatsDate(DateTime value) =>
    '${value.year}.${value.month.toString().padLeft(2, '0')}.${value.day.toString().padLeft(2, '0')}';

String formatBggPlayDate(DateTime value) =>
    '${value.year}년 ${value.month}월 ${value.day}일';

String _bggPlayMeta(BggPlaySession play) {
  final parts = <String>[
    if (play.quantity > 1) '${play.quantity}회',
    if (play.lengthMinutes != null) '${play.lengthMinutes}분',
    if (play.incomplete) '미완료',
    if (play.noWinStats) '승패 기록 없음',
  ];
  return parts.join(' · ');
}

String _bggPlayerName(BggPlayPlayer player) {
  final name = player.name.trim();
  if (name.isNotEmpty) return name;
  final username = player.username?.trim();
  if (username != null && username.isNotEmpty) return username;
  return '이름 없음';
}

String _bggScoreText(String? score) {
  final text = score?.trim();
  if (text == null || text.isEmpty) return '-';
  return _numericBggScore(text) == null ? text : '$text점';
}

double? _numericBggScore(String? score) {
  if (score == null) return null;
  return double.tryParse(score.trim());
}

class _PlayerScoreItemCard extends StatelessWidget {
  final PlayerScore playerScore;
  final int position;

  const _PlayerScoreItemCard({
    required this.playerScore,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final rank = playerScore.rank > 0 ? playerScore.rank : position;
    final isWinner = rank == 1;

    return Card(
      color: isWinner
          ? themeData.colorScheme.primaryContainer
          : themeData.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              child: Text(
                isWinner ? '🏆' : '$rank위',
                style: themeData.textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: Text(
                playerScore.name,
                style: themeData.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${playerScore.score}점',
              style: themeData.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
