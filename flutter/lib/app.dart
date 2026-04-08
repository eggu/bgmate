import 'package:bgmate_flutter/presentation/collection/game_list_screen.dart';
import 'package:bgmate_flutter/presentation/recommend/recommend_screen.dart';
import 'package:bgmate_flutter/presentation/rule_judge/rule_judge_screen.dart';
import 'package:bgmate_flutter/presentation/score_tracker/score_tracker_screen.dart';
import 'package:bgmate_flutter/presentation/shell/app_shell.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:bgmate_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: AppRoutes.collection,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.collection,
              builder: (_, _) => const GameListScreen(),
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
              path: AppRoutes.score,
              builder: (_, _) => const ScoreTrackerScreen(),
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
