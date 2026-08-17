import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/home/home_state.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:bgmate_flutter/presentation/widgets/feature_action_button.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
import 'package:bgmate_flutter/presentation/widgets/info_badge.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('오늘 플레이')),
      body: state.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _HomeMessage(
          title: '홈을 불러오지 못했습니다.',
          message: '$e',
          actionLabel: '다시 시도',
          onAction: () => ref.invalidate(homeStateProvider),
        ),
        data: (home) =>
            home.hasCollection ? _ReadyHome(state: home) : const _EmptyHome(),
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, color: cs.onPrimaryContainer),
                const SizedBox(height: 12),
                Text(
                  '컬렉션을 연결하면 플레이 준비가 빨라져요.',
                  style: tt.titleLarge?.copyWith(color: cs.onPrimaryContainer),
                ),
                const SizedBox(height: 6),
                Text(
                  'BGG 동기화나 직접 검색으로 게임을 추가하고 바로 점수 기록을 시작하세요.',
                  style: tt.bodyMedium?.copyWith(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FeatureActionButton(
          icon: Icons.sync,
          title: 'BGG 동기화',
          subtitle: '보유 게임과 플레이 기록을 가져오기',
          onPressed: () => context.go(AppRoutes.settings),
        ),
        const SizedBox(height: 10),
        FeatureActionButton(
          icon: Icons.search,
          title: '게임 검색',
          subtitle: 'BGG에서 직접 찾아 컬렉션에 추가',
          onPressed: () => context.push(AppRoutes.gameSearch),
        ),
        const SizedBox(height: 10),
        FeatureActionButton(
          icon: Icons.recommend_outlined,
          title: 'AI 추천으로 시작',
          subtitle: '인원, 시간, 분위기로 후보 찾기',
          onPressed: () => context.go(AppRoutes.recommend),
        ),
      ],
    );
  }
}

class _ReadyHome extends StatelessWidget {
  final HomeState state;

  const _ReadyHome({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(title: '바로 시작'),
          const SizedBox(height: 10),
          FeatureActionButton(
            icon: Icons.gavel_outlined,
            title: '규칙 묻기',
            subtitle: '애매한 상황을 바로 판정',
            onPressed: () => context.go(AppRoutes.ruleJudge),
          ),
          const SizedBox(height: 10),
          FeatureActionButton(
            icon: Icons.sell_outlined,
            title: '판매 후보',
            subtitle: '오래 안 한 게임과 중고 시세 보기',
            onPressed: () => context.go(AppRoutes.saleRecommend),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: '최근 게임'),
          const SizedBox(height: 10),
          for (final game in state.recentGames)
            _HomeGameRow(
              game: game,
              latestSession: state.latestSessionByBggId[game.bggId],
            ),
          if (state.salePreview.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle(title: '판매 후보'),
            const SizedBox(height: 10),
            for (final candidate in state.salePreview)
              _SalePreviewRow(candidate: candidate),
          ],
        ],
      ),
    );
  }
}

class _HomeGameRow extends StatelessWidget {
  final BoardGame game;
  final SessionHistory? latestSession;

  const _HomeGameRow({required this.game, required this.latestSession});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: SizedBox(
          width: 52,
          height: 52,
          child: GameThumbnail(url: game.thumbnail),
        ),
        title: Text(game.name),
        subtitle: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (game.minPlayers > 0 && game.maxPlayers > 0)
              InfoBadge(
                icon: Icons.group_outlined,
                label: '${game.minPlayers}-${game.maxPlayers}인',
              ),
            if (game.playingTime > 0)
              InfoBadge(
                icon: Icons.schedule_outlined,
                label: '${game.playingTime}분',
              ),
            if (latestSession != null)
              InfoBadge(
                icon: Icons.history_outlined,
                label: _formatLatestSession(latestSession!),
              ),
          ],
        ),
        trailing: IconButton.filledTonal(
          tooltip: '점수 시작',
          icon: const Icon(Icons.scoreboard_outlined),
          onPressed: () =>
              context.push(AppRoutes.scoreCreateLocation(game.bggId)),
        ),
        onTap: () => context.push(AppRoutes.gameDetailLocation(game.bggId)),
      ),
    );
  }
}

class _SalePreviewRow extends StatelessWidget {
  final SaleCandidate candidate;

  const _SalePreviewRow({required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(candidate.game.name),
        subtitle: Text(_formatUnplayed(candidate.yearsUnplayed)),
        trailing: Text('${candidate.playCount}회'),
        onTap: () => context.go(AppRoutes.saleRecommend),
      ),
    );
  }
}

class _HomeMessage extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _HomeMessage({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

String _formatUnplayed(double? years) {
  if (years == null) return '플레이 기록 없음';
  if (years < 1) return '1년 미만 미플레이';
  return '${years.round()}년 미플레이';
}

String _formatLatestSession(SessionHistory session) {
  final parts = [
    '${session.playedAt.month}월 ${session.playedAt.day}일',
    '${session.scores.length}명',
  ];
  if (session.scores.isNotEmpty) {
    final winner = session.scores.reduce((a, b) => a.score >= b.score ? a : b);
    parts.add('${winner.name} ${winner.score}점');
  }
  return parts.join(' · ');
}
