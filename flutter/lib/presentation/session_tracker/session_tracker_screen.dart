import 'package:bgmate_flutter/app.dart';
import 'package:bgmate_flutter/presentation/session_tracker/player_score_card.dart';
import 'package:bgmate_flutter/presentation/session_tracker/session_tracker_notifier.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionTrackerScreen extends ConsumerWidget {
  final int bggId;
  final List<String> playerNames;

  const SessionTrackerScreen({
    required this.bggId,
    required this.playerNames,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionTrackerProvider(bggId, playerNames));
    final notifier = ref.read(
      sessionTrackerProvider(bggId, playerNames).notifier,
    );

    // 저장 완료 시 자동 이동
    ref.listen(sessionTrackerProvider(bggId, playerNames), (_, next) {
      if (next.isSaved && context.mounted) {
        if (next.sessionId > 0) {
          context.go(AppRoutes.sessionHistoryLocation(next.sessionId));
          collectionNavigatorKey.currentState
              ?.popUntil((route) => route.isFirst);
        } else {
          context.pop(); // 컬렉션 탭으로 복귀
        }
      }
    });

    return PopScope(
      canPop: !state.isSaving, // 저장 중 백버튼 차단
      child: Scaffold(
        appBar: AppBar(title: Text(state.game.value?.name ?? '')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.players.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final player = state.players[index];
            return PlayerScoreCard(
              player: player,
              onScoreChanged: (score) => notifier.setScore(player.name, score),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: state.isSaving ? null : () => notifier.finishSession(),
            child: state.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('게임 종료'),
          ),
        ),
      ),
    );
  }
}
