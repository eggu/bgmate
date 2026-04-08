import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/collection/search_debouncer.dart';
import 'package:bgmate_flutter/presentation/collection/search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameSearchScreen extends ConsumerStatefulWidget {
  const GameSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameSearchScreenState();
}

class _GameSearchScreenState extends ConsumerState<GameSearchScreen> {
  final _controller = TextEditingController();
  final _debouncer = SearchDebouncer();

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debouncer.run(() {
      ref.read(searchNotifierProvider.notifier).search(value);
    });
  }

  void _onClear() {
    _controller.clear();
    ref.read(searchNotifierProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(title: const Text('게임 검색')),
        body: Column(
          children: [
            // ── 검색창 ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '게임 이름을 입력하세요',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _onClear,
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            // ── 결과 영역 ──
            Expanded(
              child: searchState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('검색 실패: $e')),
                data: (games) {
                  if (_controller.text.trim().isEmpty) {
                    return const Center(child: Text('게임 이름을 입력하면 검색합니다'));
                  }
                  if (games.isEmpty) {
                    return const Center(child: Text('검색 결과가 없습니다'));
                  }
                  return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) => _SearchResultItem(
                      game: games[index],
                      onAdd: () => _addToCollection(games[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCollection(BoardGame game) async {
    await ref.read(gameListProvider.notifier).addGame(game);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${game.name}을(를) 컬렉션에 추가했습니다')));
    context.pop();
  }
}

class _SearchResultItem extends StatelessWidget {
  final BoardGame game;
  final VoidCallback onAdd;

  const _SearchResultItem({required this.game, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(game.name),
      subtitle: game.yearPublished != null
          ? Text('${game.yearPublished}년 출시')
          : null,
      trailing: IconButton(
        onPressed: onAdd,
        icon: const Icon(Icons.add_circle_outline),
      ),
    );
  }
}
