import 'dart:async';

import 'package:bgmate_flutter/app.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/home/home_screen.dart';
import 'package:bgmate_flutter/presentation/home/home_state.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_sync_service.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const _game = BoardGame(
  bggId: 13,
  name: 'Catan',
  yearPublished: 1995,
  minPlayers: 3,
  maxPlayers: 4,
  playingTime: 90,
);

class _HomeReloadTick extends Notifier<int> {
  @override
  int build() => 0;

  void set(int value) => state = value;
}

final _homeReloadTickProvider = NotifierProvider<_HomeReloadTick, int>(
  _HomeReloadTick.new,
);

class _FakeGameRepository implements GameRepository {
  @override
  Future<void> addToCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async =>
      games;

  @override
  Future<BoardGame?> getGame(int id) async => id == _game.bggId ? _game : null;

  @override
  Future<List<BoardGame>> getCollection() async => const [_game];

  @override
  Future<void> removeFromCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> searchBgg(String query) async => const [];

  @override
  Stream<List<BoardGame>> watchGames() => Stream.value(const [_game]);
}

Widget _build(HomeState state) {
  return ProviderScope(
    overrides: [homeStateProvider.overrideWith((_) async => state)],
    child: MaterialApp.router(routerConfig: _router()),
  );
}

GoRouter _router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const _Destination('Settings destination'),
      ),
      GoRoute(
        path: AppRoutes.gameSearch,
        builder: (_, _) => const _Destination('Search destination'),
      ),
      GoRoute(
        path: AppRoutes.recommend,
        builder: (_, _) => const _Destination('Recommend destination'),
      ),
      GoRoute(
        path: AppRoutes.saleRecommend,
        builder: (_, _) => const _Destination('Sale destination'),
      ),
      GoRoute(
        path: AppRoutes.gameDetailPath,
        builder: (_, _) => const _Destination('Game detail destination'),
      ),
      GoRoute(
        path: AppRoutes.scoreCreatePath,
        builder: (_, _) => const _Destination('Score destination'),
      ),
    ],
  );
}

class _Destination extends StatelessWidget {
  final String text;

  const _Destination(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(text)));
  }
}

void main() {
  testWidgets('empty home shows setup actions', (tester) async {
    await tester.pumpWidget(
      _build(
        HomeState.from(
          games: const [],
          saleCandidates: const [],
          sessions: const [],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('오늘 플레이'), findsOneWidget);
    expect(find.text('BGG 동기화'), findsOneWidget);
    expect(find.text('게임 검색'), findsOneWidget);
    expect(find.text('AI 추천으로 시작'), findsOneWidget);

    await tester.tap(find.text('BGG 동기화'));
    await tester.pumpAndSettle();

    expect(find.text('Settings destination'), findsOneWidget);
  });

  testWidgets('populated home shows quick actions and sale preview', (
    tester,
  ) async {
    final state = HomeState.from(
      games: const [_game],
      saleCandidates: [
        SaleCandidate(
          game: _game,
          playCount: 2,
          lastPlayedAt: DateTime(2020, 1, 1),
          rating: null,
          score: 20,
          yearsUnplayed: 6,
        ),
      ],
      sessions: [
        SessionHistory(
          id: 1,
          game: _game,
          scores: const [PlayerScore(name: 'Kurt', score: 10, rank: 1)],
          playedAt: DateTime(2026, 7, 3),
        ),
      ],
    );

    await tester.pumpWidget(_build(state));
    await tester.pump();

    expect(find.text('점수 시작'), findsNothing);
    expect(find.byTooltip('점수 시작'), findsOneWidget);
    expect(find.text('규칙 묻기'), findsOneWidget);
    expect(find.text('판매 후보'), findsWidgets);
    expect(find.text('Catan'), findsWidgets);
    expect(find.text('7월 3일 · 1명 · Kurt 10점'), findsOneWidget);
    expect(find.text('6년 미플레이'), findsOneWidget);
    expect(find.text('최근 전적'), findsNothing);

    await tester.tap(find.text('판매 후보').first);
    await tester.pumpAndSettle();

    expect(find.text('Sale destination'), findsOneWidget);
  });

  testWidgets('recent game score button starts scoring for that game', (
    tester,
  ) async {
    final state = HomeState.from(
      games: const [_game],
      saleCandidates: const [],
      sessions: const [],
    );

    await tester.pumpWidget(_build(state));
    await tester.pump();

    await tester.tap(find.byTooltip('점수 시작'));
    await tester.pumpAndSettle();

    expect(find.text('Score destination'), findsOneWidget);
  });

  testWidgets('keeps current home visible while home state reloads', (
    tester,
  ) async {
    final state = HomeState.from(
      games: const [_game],
      saleCandidates: const [],
      sessions: const [],
    );
    final reloadCompleter = Completer<HomeState>();
    final container = ProviderContainer(
      overrides: [
        homeStateProvider.overrideWith((ref) {
          final tick = ref.watch(_homeReloadTickProvider);
          if (tick == 0) return Future.value(state);
          return reloadCompleter.future;
        }),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: _router()),
      ),
    );
    await tester.pump();

    expect(find.text('Catan'), findsOneWidget);

    container.read(_homeReloadTickProvider.notifier).set(1);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Catan'), findsOneWidget);
  });

  testWidgets(
    'opening a collection detail from home keeps shell navigation and back',
    (tester) async {
      tester.view.physicalSize = const Size(390, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final state = HomeState.from(
        games: const [_game],
        saleCandidates: const [],
        sessions: const [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeStateProvider.overrideWith((_) async => state),
            gameRepositoryProvider.overrideWithValue(_FakeGameRepository()),
            bggStartupSyncProvider.overrideWith((_) async {}),
          ],
          child: const BgMateApp(),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Catan').first);
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      expect(find.text('90분'), findsOneWidget);
    },
  );
}
