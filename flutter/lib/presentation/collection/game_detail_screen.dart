import 'package:bgmate_flutter/core/image/image_url_resolver.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_detail_notifier.dart';
import 'package:bgmate_flutter/presentation/collection/game_used_price_provider.dart';
import 'package:bgmate_flutter/presentation/widgets/external_uri_launcher.dart';
import 'package:bgmate_flutter/presentation/widgets/feature_action_button.dart';
import 'package:bgmate_flutter/presentation/widgets/info_badge.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameDetailScreen extends ConsumerWidget {
  final int bggId;

  const GameDetailScreen({super.key, required this.bggId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(gameDetailProvider(bggId));

    return Scaffold(
      appBar: AppBar(
        title: detailState.maybeWhen(
          data: (game) => Text(game?.name ?? ''),
          orElse: () => const Text('게임 상세'),
        ),
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (game) {
          if (game == null) {
            return const Center(child: Text('게임을 찾을 수 없습니다'));
          }
          return _GameDetailBody(game: game);
        },
      ),
    );
  }
}

class _GameDetailBody extends StatelessWidget {
  final BoardGame game;

  const _GameDetailBody({required this.game});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 썸네일 — thumbnailUrl이 있으면 표시, 없으면 플레이스홀더
        if (game.thumbnail.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              resolveImageUrl(game.thumbnail),
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const _ThumbnailPlaceholder(),
            ),
          )
        else
          const _ThumbnailPlaceholder(),
        const SizedBox(height: 24),
        // 게임 이름
        Text(game.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (game.minPlayers > 0 || game.maxPlayers > 0)
              InfoBadge(
                icon: Icons.groups_outlined,
                label: _formatPlayers(game),
              ),
            if (game.playingTime > 0)
              InfoBadge(
                icon: Icons.schedule_outlined,
                label: '${game.playingTime}분',
              ),
          ],
        ),
        ...[
          const SizedBox(height: 10),
          Text(
            '${game.yearPublished}년 출시',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 8),
        Text(
          'BGG ID: ${game.bggId}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        FeatureActionButton(
          icon: Icons.scoreboard_outlined,
          title: '점수 시작',
          subtitle: '플레이어를 추가하고 바로 기록',
          onPressed: () =>
              context.go(AppRoutes.scoreCreateLocation(game.bggId)),
        ),
        const SizedBox(height: 10),
        FeatureActionButton(
          icon: Icons.gavel_outlined,
          title: '규칙 묻기',
          subtitle: '${game.name} 규칙 상황을 질문',
          onPressed: () =>
              context.go(AppRoutes.ruleJudgeLocation(gameName: game.name)),
        ),
        const SizedBox(height: 16),
        _UsedPriceCard(game: game),
      ],
    );
  }
}

String _formatPlayers(BoardGame game) {
  if (game.minPlayers > 0 && game.maxPlayers > 0) {
    if (game.minPlayers == game.maxPlayers) return '${game.minPlayers}명';
    return '${game.minPlayers}-${game.maxPlayers}명';
  }
  if (game.minPlayers > 0) return '${game.minPlayers}명+';
  return '최대 ${game.maxPlayers}명';
}

class _UsedPriceCard extends ConsumerWidget {
  final BoardGame game;

  const _UsedPriceCard({required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(usedPriceApiServiceProvider);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    if (!service.isConfigured) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '중고 시세 API가 설정되지 않았습니다.',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    final priceState = ref.watch(gameUsedPriceProvider(game));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sell_outlined, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(child: Text('중고 시세', style: tt.titleMedium)),
                IconButton(
                  tooltip: '다시 조회',
                  onPressed: () => ref.invalidate(gameUsedPriceProvider(game)),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            priceState.when(
              loading: () => const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('보드라이프 시세 조회 중'),
                ],
              ),
              error: (_, _) => Text(
                '시세 조회에 실패했습니다.',
                style: tt.bodyMedium?.copyWith(color: cs.error),
              ),
              data: (price) {
                if (price == null) {
                  return Text(
                    '보드라이프에서 게임을 찾지 못했습니다.',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  );
                }

                if (price.listingCount == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '현재 매물이 없습니다.',
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _BoardlifeShopButton(uri: price.shopUri),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '최저가 ${_formatWon(price.minPrice)}',
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '평균가 ${_formatWon(price.avgPrice)} · 매물 ${price.listingCount}개',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _BoardlifeShopButton(uri: price.shopUri),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardlifeShopButton extends StatelessWidget {
  final Uri uri;

  const _BoardlifeShopButton({required this.uri});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => openExternalUri(context, uri),
      icon: const Icon(Icons.open_in_new),
      label: const Text('보드라이프 중고 페이지'),
    );
  }
}

String _formatWon(int? value) {
  if (value == null) return '-';
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return '$buffer원';
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.games, size: 64),
    );
  }
}
