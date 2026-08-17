import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/collection/search_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGameRepository implements GameRepository {
  int searchCallCount = 0;
  int enrichCallCount = 0;

  Future<List<BoardGame>> Function(String query)? onSearchBgg;
  Future<List<BoardGame>> Function(List<BoardGame> games)? onEnrichWithDetails;

  @override
  Future<List<BoardGame>> searchBgg(String query) async {
    searchCallCount++;
    final handler = onSearchBgg;
    if (handler == null) return [];
    return handler(query);
  }

  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async {
    enrichCallCount++;
    final handler = onEnrichWithDetails;
    if (handler == null) return games;
    return handler(games);
  }

  @override
  Future<void> addToCollection(BoardGame game) {
    throw UnimplementedError();
  }

  @override
  Future<List<BoardGame>> getCollection() {
    throw UnimplementedError();
  }

  @override
  Future<BoardGame?> getGame(int id) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromCollection(BoardGame game) {
    throw UnimplementedError();
  }

  @override
  Stream<List<BoardGame>> watchGames() {
    throw UnimplementedError();
  }
}

BoardGame _game(int id) => BoardGame(
      bggId: id,
      name: 'Game $id',
      yearPublished: 2000 + id,
    );

BoardGame _enriched(BoardGame game) =>
    game.copyWith(minPlayers: 2, maxPlayers: 4, thumbnail: 'thumb-${game.bggId}');

void main() {
  late _FakeGameRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = _FakeGameRepository();
    container = ProviderContainer(
      overrides: [gameRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  void listen() => container.listen(searchNotifierProvider, (_, __) {});

  group('SearchNotifier', () {
    test('공백 쿼리는 reset 후 빈 데이터 상태를 유지하고 검색 API를 호출하지 않는다', () async {
      listen();

      await container.read(searchNotifierProvider.notifier).search('   ');

      final state = container.read(searchNotifierProvider);
      expect(state, isA<AsyncData<List<BoardGame>>>());
      expect(state.value, isEmpty);
      expect(repo.searchCallCount, 0);
      expect(repo.enrichCallCount, 0);
    });

    test('searchBgg 실패 시 AsyncError로 전이하고 보강 API는 호출하지 않는다', () async {
      repo.onSearchBgg = (_) => Future<List<BoardGame>>.error(Exception('search failed'));
      listen();

      await container.read(searchNotifierProvider.notifier).search('catan');

      final state = container.read(searchNotifierProvider);
      expect(state, isA<AsyncError<List<BoardGame>>>());
      expect(repo.searchCallCount, 1);
      expect(repo.enrichCallCount, 0);
    });

    test('검색 성공 시 원본 결과를 먼저 노출하고 첫 배치를 보강한다', () async {
      final enrichCompleter = Completer<List<BoardGame>>();
      repo.onSearchBgg = (_) async => [_game(1), _game(2)];
      repo.onEnrichWithDetails = (_) => enrichCompleter.future;
      listen();

      final searchFuture =
          container.read(searchNotifierProvider.notifier).search('catan');

      await Future<void>.delayed(Duration.zero);
      final midState = container.read(searchNotifierProvider);
      expect(midState, isA<AsyncData<List<BoardGame>>>());
      expect(midState.value?.map((e) => e.minPlayers), everyElement(0));

      enrichCompleter.complete([_enriched(_game(1)), _enriched(_game(2))]);
      await searchFuture;

      final finalState = container.read(searchNotifierProvider);
      final notifier = container.read(searchNotifierProvider.notifier);
      expect(finalState.value?.map((e) => e.minPlayers), everyElement(2));
      expect(notifier.enrichedUpTo, 2);
      expect(notifier.hasMoreToEnrich, false);
    });

    test('loadNextBatch 중복 호출 시 같은 배치는 한 번만 보강된다', () async {
      final firstBatchCompleter = Completer<List<BoardGame>>();
      final nextBatchCompleter = Completer<List<BoardGame>>();
      var enrichInvocation = 0;

      repo.onSearchBgg = (_) async => List.generate(25, (i) => _game(i + 1));
      repo.onEnrichWithDetails = (games) {
        enrichInvocation++;
        if (enrichInvocation == 1) return firstBatchCompleter.future;
        return nextBatchCompleter.future;
      };
      listen();

      final searchFuture =
          container.read(searchNotifierProvider.notifier).search('terraforming');
      firstBatchCompleter.complete(
        List.generate(20, (i) => _enriched(_game(i + 1))),
      );
      await searchFuture;

      final notifier = container.read(searchNotifierProvider.notifier);
      final load1 = notifier.loadNextBatch();
      final load2 = notifier.loadNextBatch();

      await Future<void>.delayed(Duration.zero);
      expect(repo.enrichCallCount, 2);

      nextBatchCompleter.complete(
        List.generate(5, (i) => _enriched(_game(i + 21))),
      );
      await Future.wait([load1, load2]);

      final state = container.read(searchNotifierProvider);
      expect(state.value?.where((e) => e.minPlayers == 2).length, 25);
    });

    test('이전 세대 보강 응답은 새 검색 상태를 덮어쓰지 않는다', () async {
      final search1EnrichCompleter = Completer<List<BoardGame>>();

      repo.onSearchBgg = (query) async {
        if (query == 'old') return [_game(1)];
        return [_game(2)];
      };
      repo.onEnrichWithDetails = (games) {
        if (games.first.bggId == 1) return search1EnrichCompleter.future;
        return Future.value([_enriched(games.first)]);
      };
      listen();

      final oldSearch =
          container.read(searchNotifierProvider.notifier).search('old');
      await Future<void>.delayed(Duration.zero);

      final newSearch =
          container.read(searchNotifierProvider.notifier).search('new');
      await newSearch;

      search1EnrichCompleter.complete([_enriched(_game(1))]);
      await oldSearch;

      final state = container.read(searchNotifierProvider);
      expect(state.value, hasLength(1));
      expect(state.value?.first.bggId, 2);
      expect(state.value?.first.minPlayers, 2);
    });
  });
}
