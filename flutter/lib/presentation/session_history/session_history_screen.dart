import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_notifier.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('전적 기록')),
      body: sessions.when(
        data: (sessions) => sessions.isEmpty
            ? const Text('-')
            : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (_, i) => _SessionCard(
                  session: sessions[i],
                  onDetail: () => {},
                  winner: sessions[i].scores.isEmpty
                      ? null
                      : sessions[i].scores.reduce(
                          (a, b) => a.score >= b.score ? a : b,
                        ),
                ),
              ),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('오류가 발생했습니다.\n$e', textAlign: TextAlign.center)],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionHistory session;
  final VoidCallback onDetail;
  final PlayerScore? winner;

  const _SessionCard({
    super.key,
    required this.session,
    required this.onDetail,
    this.winner,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SizedBox(
          width: 56,
          child: GameThumbnail(url: session.game.thumbnail),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 6,
              children: [
                Text(
                  session.game.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${session.playedAt.month}월 ${session.playedAt.day}일',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Text(
              '${session.scores.length}명: ${session.scores.map((e) => e.name).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: winner != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('🏆 ${winner?.name}'),
                  Text(
                    '${winner?.score}점',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
