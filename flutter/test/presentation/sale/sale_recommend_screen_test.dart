import 'package:bgmate_flutter/data/remote/used_price_api_service.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/used_price.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:bgmate_flutter/presentation/sale/sale_recommend_provider.dart';
import 'package:bgmate_flutter/presentation/sale/sale_recommend_screen.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _PassthroughGameRepository implements GameRepository {
  _PassthroughGameRepository([this.collection = const []]);

  final List<BoardGame> collection;

  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async =>
      games;

  @override
  Future<void> addToCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> getCollection() async => collection;

  @override
  Future<BoardGame?> getGame(int id) async => null;

  @override
  Future<void> removeFromCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> searchBgg(String query) async => [];

  @override
  Stream<List<BoardGame>> watchGames() => Stream.value(collection);
}

class _FakeUsedPriceApiService extends UsedPriceApiService {
  final UsedPrice price;

  _FakeUsedPriceApiService(this.price)
    : super(dio: Dio(), baseUrl: 'https://example.com');

  @override
  Future<UsedPrice?> fetchUsedPrice(
    BoardGame game, {
    String? originalName,
  }) async => price;
}

void main() {
  testWidgets('빈 컬렉션 판매 화면은 동기화와 검색으로 이어진다', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.saleRecommend,
      routes: [
        GoRoute(
          path: AppRoutes.saleRecommend,
          builder: (_, _) => const SaleRecommendScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (_, _) => const _Destination('Settings destination'),
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
          gameRepositoryProvider.overrideWithValue(
            _PassthroughGameRepository(),
          ),
          saleCandidatesProvider.overrideWith((_) async => const []),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('컬렉션이 비어 있어요'), findsOneWidget);
    expect(find.text('BGG 동기화'), findsOneWidget);
    expect(find.text('게임 검색'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.text('게임 검색'));
    await tester.pumpAndSettle();

    expect(find.text('Search destination'), findsOneWidget);
  });

  testWidgets('판매 추천 항목에 최저가, 최고가, 평균가를 표시한다', (tester) async {
    const game = BoardGame(bggId: 13, name: 'Catan', yearPublished: 1995);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          saleCandidatesProvider.overrideWith(
            (_) async => [
              SaleCandidate(
                game: game,
                playCount: 2,
                lastPlayedAt: DateTime(2020, 1, 1),
                rating: null,
                score: 10,
                yearsUnplayed: 6,
              ),
            ],
          ),
          gameListProvider.overrideWith(
            () => _StaticGameListNotifier(const [game]),
          ),
          gameRepositoryProvider.overrideWithValue(
            _PassthroughGameRepository(const [game]),
          ),
          usedPriceApiServiceProvider.overrideWithValue(
            _FakeUsedPriceApiService(
              UsedPrice(
                bggId: 13,
                boardlifeId: '274',
                boardlifeName: '카탄의 개척자',
                shopUrl: 'https://boardlife.co.kr/game/274/shop',
                minPrice: 10000,
                maxPrice: 30000,
                avgPrice: 20000,
                listingCount: 3,
                cachedAt: DateTime(2026, 7, 2),
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: SaleRecommendScreen()),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('판매 후보'), findsOneWidget);
    expect(find.text('6년 미플레이'), findsOneWidget);
    expect(find.text('최근 플레이 2020.01.01'), findsOneWidget);
    expect(find.text('2회 플레이'), findsOneWidget);
    expect(find.textContaining('최저가 10,000원'), findsOneWidget);
    expect(find.textContaining('최고가 30,000원'), findsOneWidget);
    expect(find.textContaining('평균가 20,000원'), findsOneWidget);
  });
}

class _StaticGameListNotifier extends GameListNotifier {
  _StaticGameListNotifier(this.games);

  final List<BoardGame> games;

  @override
  Future<List<BoardGame>> build() async => games;
}

class _Destination extends StatelessWidget {
  final String text;

  const _Destination(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(text)));
  }
}
