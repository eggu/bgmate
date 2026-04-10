import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
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
      appBar: AppBar(title: const Text('전적 상세')),
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

class _SessionHistoryDetailBody extends StatelessWidget {
  final SessionHistory history;

  const _SessionHistoryDetailBody({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final players = history.scores.toList()..sort((a, b) => b.score - a.score);
    final themeData = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: players.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${history.playedAt.year}년 ${history.playedAt.month}월 ${history.playedAt.day}일',
              style: themeData.textTheme.titleLarge?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return _PlayerScoreItemCard(playerScore: players[i - 1]);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 8),
    );
  }
}

class _PlayerScoreItemCard extends StatelessWidget {
  final PlayerScore playerScore;

  const _PlayerScoreItemCard({super.key, required this.playerScore});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isWinner = playerScore.rank == 1;

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
                isWinner ? '🏆' : '${playerScore.rank}위',
                style: themeData.textTheme.titleMedium,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                playerScore.name,
                style: themeData.textTheme.titleMedium,
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
