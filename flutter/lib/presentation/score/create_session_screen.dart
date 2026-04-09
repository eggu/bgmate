import 'package:bgmate_flutter/presentation/score/create_session_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateSessionScreen extends ConsumerStatefulWidget {
  final int bggId;

  const CreateSessionScreen({required this.bggId, super.key});

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addPlayer() {
    ref
        .read(createSessionProvider(widget.bggId).notifier)
        .addPlayer(_controller.text);
    _controller.clear();
    _focusNode.requestFocus(); // 입력창 포커스 유지
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createSessionProvider(widget.bggId));

    return PopScope(
      canPop: true, // Day 2 트러블슈팅 문제 2번 — push 화면 백버튼 처리
      child: Scaffold(
        appBar: AppBar(
          title: state.game.when(
            data: (game) => Text(game?.name ?? '세션 만들기'),
            loading: () => const Text('불러오는 중...'),
            error: (_, __) => const Text('세션 만들기'),
          ),
        ),
        body: Column(
          children: [
            // 플레이어 이름 입력창
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: '플레이어 이름',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addPlayer(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addPlayer,
                    icon: const Icon(Icons.person_add),
                  ),
                ],
              ),
            ),

            // 추가된 플레이어 목록
            Expanded(
              child: ListView.builder(
                itemCount: state.playerNames.length,
                itemBuilder: (context, index) {
                  final name = state.playerNames[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(name),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => ref
                          .read(createSessionProvider(widget.bggId).notifier)
                          .removePlayer(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: state.canStart
                ? () async {
                    final _ = await ref
                        .read(createSessionProvider(widget.bggId).notifier)
                        .confirmSession();
                    // STEP 3에서 점수 트래커 화면 경로로 교체 예정
                    context.pop();
                  }
                : null,
            child: const Text('게임 시작'),
          ),
        ),
      ),
    );
  }
}
