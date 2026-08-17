import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
import 'package:bgmate_flutter/presentation/widgets/info_badge.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameListScreen extends ConsumerWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 컬렉션'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.gameSearch),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('오류가 발생했습니다.\n$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.read(gameListProvider.notifier).refresh(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (games) => games.isEmpty
            ? _EmptyCollectionState(
                onSearch: () => context.push(AppRoutes.gameSearch),
              )
            : ListView.builder(
                itemCount: games.length,
                itemBuilder: (_, i) => _GameCard(
                  game: games[i],
                  onDetail: () => context.push(
                    AppRoutes.gameDetailLocation(games[i].bggId),
                  ),
                  onCreateSession: () => context.push(
                    AppRoutes.scoreCreateLocation(games[i].bggId),
                  ),
                  onDelete: () => _confirmDelete(context, ref, games[i]),
                ),
              ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, BoardGame game) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('컬렉션에서 삭제'),
        content: Text('${game.name}을(를) 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              ref.read(gameListProvider.notifier).removeGame(game);
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              '삭제',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final BoardGame game;
  final VoidCallback onDetail;
  final VoidCallback onCreateSession;
  final VoidCallback onDelete;

  const _GameCard({
    required this.game,
    required this.onDetail,
    required this.onCreateSession,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SizedBox(
          width: 56,
          height: 56,
          child: GameThumbnail(url: game.thumbnail),
        ),
        title: Text(
          game.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: _buildSubtitle(context, game),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: onCreateSession,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),

        onTap: onDetail,
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context, BoardGame game) {
    final badges = <Widget>[];

    if (game.yearPublished > 0) {
      badges.add(
        InfoBadge(icon: Icons.event_outlined, label: '${game.yearPublished}'),
      );
    }
    if (game.minPlayers > 0 && game.maxPlayers > 0) {
      badges.add(
        InfoBadge(
          icon: Icons.group_outlined,
          label: '${game.minPlayers}-${game.maxPlayers}인',
        ),
      );
    } else if (game.minPlayers > 0) {
      badges.add(
        InfoBadge(icon: Icons.group_outlined, label: '${game.minPlayers}인+'),
      );
    }
    if (game.playingTime > 0) {
      badges.add(
        InfoBadge(icon: Icons.schedule_outlined, label: '${game.playingTime}분'),
      );
    }

    if (badges.isEmpty) return null;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(spacing: 6, runSpacing: 6, children: badges),
    );
  }
}

class _EmptyCollectionState extends StatelessWidget {
  const _EmptyCollectionState({required this.onSearch});

  final VoidCallback onSearch;

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
                Icons.library_books_outlined,
                size: 36,
                color: cs.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '컬렉션이 비어있어요',
              style: tt.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '소유한 보드게임을 추가하고\nAI 추천과 전적 관리를 활용해보세요.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search, size: 18),
              label: const Text('게임 검색하기'),
            ),
          ],
        ),
      ),
    );
  }
}
