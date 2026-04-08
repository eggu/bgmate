import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/collection/search_debouncer.dart';
import 'package:bgmate_flutter/presentation/collection/search_notifier.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    // 스크롤이 80% 이상 내려갔을 때 다음 배치 로드
    if (pos.pixels >= pos.maxScrollExtent * 0.8) {
      ref.read(searchNotifierProvider.notifier).loadNextBatch();
    }
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
    final notifier = ref.read(searchNotifierProvider.notifier);

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
                  final enrichedUpTo = notifier.enrichedUpTo;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: games.length + (notifier.hasMoreToEnrich ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == games.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return _SearchResultItem(
                        game: games[index],
                        isEnriching: index >= enrichedUpTo,
                        onAdd: () => _addToCollection(games[index]),
                      );
                    },
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
  final bool isEnriching;
  final VoidCallback onAdd;

  const _SearchResultItem({
    required this.game,
    required this.isEnriching,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: GameThumbnail(url: game.thumbnail, isEnriching: isEnriching),
      ),
      title: Text(game.name),
      subtitle: _buildSubtitle(game),
      trailing: IconButton(
        onPressed: onAdd,
        icon: const Icon(Icons.add_circle_outline),
      ),
    );
  }

  Widget? _buildSubtitle(BoardGame game) {
    final parts = <String>[];

    if (game.yearPublished > 0) {
      parts.add('${game.yearPublished}년');
    }

    if (game.minPlayers > 0 && game.maxPlayers > 0) {
      parts.add('${game.minPlayers}~${game.maxPlayers}인');
    } else if (game.minPlayers > 0) {
      parts.add('${game.minPlayers}인+');
    }

    if (game.playingTime > 0) {
      parts.add('${game.playingTime}분');
    }

    if (parts.isEmpty) return null;
    return Text(parts.join(' · '));
  }
}

