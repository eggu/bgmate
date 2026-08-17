import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/theme/app_theme.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_notifier.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_sync_service.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionHistoryProvider);
    final bggStartupSync = ref.watch(bggStartupSyncProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('전적')),
      body: Column(
        children: [
          _BggSyncStatusBanner(sync: bggStartupSync),
          Expanded(
            child: sessions.when(
              data: (sessions) => sessions.isEmpty
                  ? const _EmptyHistoryState()
                  : ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (_, i) => _SessionCard(
                        session: sessions[i],
                        onDetail: () => context.push(
                          AppRoutes.sessionHistoryLocation(sessions[i].id),
                        ),
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
                  children: [
                    Text('오류가 발생했습니다.\n$e', textAlign: TextAlign.center),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class _BggSyncStatusBanner extends StatelessWidget {
  final AsyncValue<void> sync;

  const _BggSyncStatusBanner({required this.sync});

  @override
  Widget build(BuildContext context) {
    if (sync.isLoading) {
      return const _SyncBanner(
        icon: Icons.sync,
        title: 'BGG 전적 동기화 중',
        progress: true,
      );
    }

    if (sync.hasError) {
      return const _SyncBanner(
        icon: Icons.error_outline,
        title: 'BGG 전적 동기화 실패',
        message: '설정 탭에서 다시 시도하세요.',
      );
    }

    return const SizedBox.shrink();
  }
}

class _SyncBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final bool progress;

  const _SyncBanner({
    required this.icon,
    required this.title,
    this.message,
    this.progress = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ColoredBox(
      color: cs.primaryContainer,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: cs.onPrimaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (message != null)
                      Text(
                        message!,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                  ],
                ),
              ),
              if (progress)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionHistory session;
  final VoidCallback onDetail;
  final PlayerScore? winner;

  const _SessionCard({
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
          spacing: 6,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              session.scores.isEmpty
                  ? '점수 기록 없음'
                  : '${session.scores.length}명: ${session.scores.map((e) => e.name).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: winner != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🏆 ${winner?.name}'),
                  Text(
                    '${winner?.score}점',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryText(context),
                    ),
                  ),
                ],
              )
            : null,
        onTap: onDetail,
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.scoreboard_outlined,
                size: 36,
                color: cs.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '아직 전적이 없어요',
              style: tt.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '게임을 플레이하고 점수를 기록하면\n여기에 전적이 차곡차곡 쌓여요.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.casino_outlined),
                  label: const Text('오늘 플레이'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.gameSearch),
                  icon: const Icon(Icons.search),
                  label: const Text('게임 검색'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
