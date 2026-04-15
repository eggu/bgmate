import 'package:bgmate_flutter/core/image/image_url_resolver.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        ...[
          const SizedBox(height: 8),
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
      ],
    );
  }
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
