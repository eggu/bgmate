import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/domain/repository/session_repository.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_stats_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_screen.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_sync_service.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeSessionRepository implements SessionRepository {
  _FakeSessionRepository(this.sessions);

  final List<SessionHistory> sessions;

  @override
  Stream<List<SessionHistory>> watchSessions() => Stream.value(sessions);

  @override
  Future<void> deleteSession(int id) => throw UnimplementedError();

  @override
  Future<SessionHistory> getSession(int id) => throw UnimplementedError();

  @override
  Future<int> saveSession(int bggId, List<PlayerScore> scores) =>
      throw UnimplementedError();
}

void main() {
  testWidgets('빈 전적 화면은 오늘 플레이와 게임 검색으로 이동할 수 있다', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.session,
      routes: [
        GoRoute(
          path: AppRoutes.session,
          builder: (_, _) => const SessionHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (_, _) => const _Destination('Home destination'),
        ),
        GoRoute(
          path: AppRoutes.gameSearch,
          builder: (_, _) => const _Destination('Search destination'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(
            _FakeSessionRepository(const []),
          ),
          bggStartupSyncProvider.overrideWith((_) async {}),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    expect(find.text('아직 전적이 없어요'), findsOneWidget);
    expect(find.text('오늘 플레이'), findsOneWidget);
    expect(find.text('게임 검색'), findsOneWidget);

    await tester.tap(find.text('오늘 플레이'));
    await tester.pumpAndSettle();

    expect(find.text('Home destination'), findsOneWidget);
  });

  testWidgets('전적 목록은 BGG 게임별 집계가 있어도 전적 단위 세션만 표시한다', (tester) async {
    const game = BoardGame(
      bggId: 13,
      name: 'Catan',
      yearPublished: 1995,
      thumbnail: '',
    );
    final repo = _FakeSessionRepository([
      SessionHistory(
        id: 1,
        game: game,
        scores: const [
          PlayerScore(name: 'Alice', score: 10, rank: 1),
          PlayerScore(name: 'Bob', score: 8, rank: 2),
        ],
        playedAt: DateTime(2026, 7, 2),
      ),
      SessionHistory(
        id: 2,
        game: game,
        scores: const [],
        playedAt: DateTime(2026, 7, 1),
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(repo),
          bggStartupSyncProvider.overrideWith((_) async {}),
          bggPlayStatsProvider.overrideWith(
            (_) async => const [
              BggPlayStatsEntry(
                game: game,
                playCount: 5,
                lastPlayedAt: null,
                rating: null,
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: SessionHistoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('BGG 동기화 전적'), findsNothing);
    expect(find.text('상세 전적 기록'), findsNothing);
    expect(find.text('2명: Alice, Bob'), findsOneWidget);
    expect(find.text('점수 기록 없음'), findsOneWidget);
  });

  testWidgets('BGG 시작 동기화 중이면 전적 목록 상단에 상태를 표시한다', (tester) async {
    final syncCompleter = Completer<void>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(
            _FakeSessionRepository(const []),
          ),
          bggStartupSyncProvider.overrideWith((_) => syncCompleter.future),
        ],
        child: const MaterialApp(home: SessionHistoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('BGG 전적 동기화 중'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    syncCompleter.complete();
  });
}

class _Destination extends StatelessWidget {
  final String text;

  const _Destination(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(text)));
  }
}
