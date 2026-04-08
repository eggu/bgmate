import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameListScreen extends ConsumerWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameListProvider);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 컬렉션'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
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
            ? const Center(child: Text('컬렉션이 비어있습니다'))
            : ListView.builder(
                itemCount: games.length,
                itemBuilder: (_, i) => _GameCard(game: games[i]),
              ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final BoardGame game;

  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          game.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${game.minPlayers}~${game.maxPlayers}인 · ${game.playingTime}분',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: 게임 상세 화면으로 이동
        },
      ),
    );
  }
}
