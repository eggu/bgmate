import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
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
            ? const Center(child: Text('게임을 추가해보세요'))
            : ListView.builder(
                itemCount: games.length,
                itemBuilder: (_, i) => _GameCard(
                  game: games[i],
                  onDetail: () => context.push(
                    AppRoutes.gameDetailLocation(games[i].bggId),
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
  final VoidCallback onDelete;

  const _GameCard({
    required this.game,
    required this.onDetail,
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
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
        onTap: onDetail,
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context, BoardGame game) {
    final parts = <String>[];

    if (game.yearPublished > 0) parts.add('${game.yearPublished}년');
    if (game.minPlayers > 0 && game.maxPlayers > 0) {
      parts.add('${game.minPlayers}~${game.maxPlayers}인');
    } else if (game.minPlayers > 0) {
      parts.add('${game.minPlayers}인+');
    }
    if (game.playingTime > 0) parts.add('${game.playingTime}분');

    if (parts.isEmpty) return null;
    return Text(
      parts.join(' · '),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

