import 'package:bgmate_flutter/presentation/account/account_screen.dart';
import 'package:bgmate_flutter/presentation/collection/game_detail_screen.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_screen.dart';
import 'package:bgmate_flutter/presentation/collection/game_search_screen.dart';
import 'package:bgmate_flutter/presentation/recommend/recommend_screen.dart';
import 'package:bgmate_flutter/presentation/rule_judge/rule_judge_screen.dart';
import 'package:bgmate_flutter/presentation/score/create_session_screen.dart';
import 'package:bgmate_flutter/presentation/session_tracker/session_tracker_screen.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_detail_screen.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_screen.dart';
import 'package:bgmate_flutter/presentation/shell/app_shell.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:bgmate_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final collectionNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: AppRoutes.collection,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: collectionNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.collection,
              builder: (_, _) => const GameListScreen(),
            ),
            GoRoute(
              path: AppRoutes.accountSettings,
              builder: (_, _) => const AccountScreen(),
            ),
            GoRoute(
              path: AppRoutes.gameSearch,
              builder: (_, _) => const GameSearchScreen(),
            ),
            GoRoute(
              path: AppRoutes.gameDetailPath,
              builder: (context, state) {
                final bggId = int.parse(
                  state.pathParameters[AppRoutes.bggIdParam]!,
                );
                return GameDetailScreen(bggId: bggId);
              },
            ),
            GoRoute(
              path: AppRoutes.scoreCreatePath,
              builder: (context, state) {
                final bggId = int.parse(
                  state.pathParameters[AppRoutes.bggIdParam]!,
                );
                return CreateSessionScreen(bggId: bggId);
              },
            ),
            GoRoute(
              path: AppRoutes.scoreTrackerPath,
              builder: (context, state) {
                final bggId = int.parse(
                  state.pathParameters[AppRoutes.bggIdParam]!,
                );
                final playerNames = state.extra as List<String>;
                return SessionTrackerScreen(
                  bggId: bggId,
                  playerNames: playerNames,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.ruleJudge,
              builder: (_, _) => const RuleJudgeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.recommend,
              builder: (_, _) => const RecommendScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.session,
              builder: (_, _) => const SessionHistoryScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.sessionHistoryPath,
                  builder: (context, state) {
                    final sessionId = int.parse(
                      state.pathParameters[AppRoutes.sessionIdParam]!,
                    );
                    return SessionHistoryDetailScreen(sessionId: sessionId);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class BgMateApp extends ConsumerWidget {
  const BgMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'BGMate',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
