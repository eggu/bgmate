import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/collection/game_detail_screen.dart';
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

void main() {
  testWidgets('게임 상세 규칙 묻기는 선택한 게임 이름을 판정 화면으로 넘긴다', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.gameDetailLocation(_game.bggId),
      routes: [
        GoRoute(
          path: AppRoutes.gameDetailPath,
          builder: (_, state) {
            final bggId = int.parse(
              state.pathParameters[AppRoutes.bggIdParam]!,
            );
            return GameDetailScreen(bggId: bggId);
          },
        ),
        GoRoute(
          path: AppRoutes.ruleJudge,
          builder: (_, state) => _Destination(
            state.uri.queryParameters['gameName'] ?? 'No game selected',
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FakeGameRepository()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Catan'), findsWidgets);
    expect(find.text('3-4명'), findsOneWidget);
    expect(find.text('90분'), findsOneWidget);

    await tester.tap(find.text('규칙 묻기'));
    await tester.pumpAndSettle();

    expect(find.text('Catan'), findsOneWidget);
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
