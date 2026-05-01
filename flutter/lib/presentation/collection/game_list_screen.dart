import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/sort_option.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
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
            icon: const Icon(Icons.tune),
            tooltip: '필터',
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.gameSearch),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.accountSettings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          const _SortChipsRow(),
          Expanded(
            child: gameAsync.when(
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
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _FilterBottomSheetPlaceholder(),
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

class _SortChipsRow extends ConsumerWidget {
  const _SortChipsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(gameListSortOptionProvider);
    final notifier = ref.read(gameListSortOptionProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  _SortChip(
                    label: '추가순',
                    selected: sortOption.field == SortField.addedAt,
                    onTap: () => notifier.setField(SortField.addedAt),
                  ),
                  _SortChip(
                    label: '이름순',
                    selected: sortOption.field == SortField.name,
                    onTap: () => notifier.setField(SortField.name),
                  ),
                  _SortChip(
                    label: '출시연도',
                    selected: sortOption.field == SortField.yearPublished,
                    onTap: () => notifier.setField(SortField.yearPublished),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              sortOption.order == SortOrder.asc
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            onPressed: notifier.toggleOrder,
            tooltip: sortOption.order == SortOrder.asc ? '오름차순' : '내림차순',
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      onSelected: (_) => onTap(),
    );
  }
}

class _FilterBottomSheetPlaceholder extends StatelessWidget {
  const _FilterBottomSheetPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            '필터 기능 준비 중',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '곧 플레이어 수, 플레이 시간 등으로 필터링할 수 있어요.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
