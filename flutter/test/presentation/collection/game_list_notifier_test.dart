import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGameRepository implements GameRepository {
  final StreamController<List<BoardGame>> gamesController =
      StreamController<List<BoardGame>>.broadcast();

  int watchGamesCallCount = 0;
  int enrichCallCount = 0;
  int getCollectionCallCount = 0;
  final List<BoardGame> addedGames = [];
  final List<List<BoardGame>> enrichInputs = [];

  Future<List<BoardGame>> Function(List<BoardGame> games)? onEnrichWithDetails;
  Future<List<BoardGame>> Function()? onGetCollection;

  @override
  Stream<List<BoardGame>> watchGames() {
    watchGamesCallCount++;
    return gamesController.stream;
  }

  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async {
    enrichCallCount++;
    enrichInputs.add(games);
    final handler = onEnrichWithDetails;
    if (handler == null) return games;
    return handler(games);
  }

  @override
  Future<void> addToCollection(BoardGame game) async {
    addedGames.add(game);
  }

  @override
  Future<List<BoardGame>> getCollection() async {
    getCollectionCallCount++;
    final handler = onGetCollection;
    if (handler == null) return [];
    return handler();
  }

  @override
  Future<List<BoardGame>> searchBgg(String query) {
    throw UnimplementedError();
  }

  @override
  Future<BoardGame?> getGame(int id) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromCollection(BoardGame game) async {}

  Future<void> dispose() => gamesController.close();
}

BoardGame _game(
  int id, {
  int minPlayers = 0,
  int maxPlayers = 0,
  bool isInCollection = false,
}) =>
    BoardGame(
      bggId: id,
      name: 'Game $id',
      yearPublished: 2000 + id,
      minPlayers: minPlayers,
      maxPlayers: maxPlayers,
      isInCollection: isInCollection,
    );

void main() {
  late _FakeGameRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = _FakeGameRepository();
    container = ProviderContainer(
      overrides: [gameRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(() async {
      await repo.dispose();
      container.dispose();
    });
  });

  group('GameListNotifier', () {
    test('build는 watchGames 첫 이벤트를 초기값으로 사용하고 이후 이벤트를 반영한다', () async {
      final sub = container.listen(gameListProvider, (_, __) {});
      addTearDown(sub.close);

      final initial = [_game(1, minPlayers: 2, maxPlayers: 4)];
      final updated = [_game(2, minPlayers: 3, maxPlayers: 5)];

      final future = container.read(gameListProvider.future);
      await Future<void>.delayed(Duration.zero);
      repo.gamesController.add(initial);

      final value = await future;
      expect(value, initial);
      expect(repo.watchGamesCallCount, 2);

      await Future<void>.delayed(Duration.zero);
      repo.gamesController.add(updated);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(gameListProvider);
      expect(state.value, updated);
    });

    test('stale 게임 21개는 20/1 배치로 보강되고 저장 시 isInCollection=true로 강제된다', () async {
      final sub = container.listen(gameListProvider, (_, __) {});
      addTearDown(sub.close);

      final initial = List.generate(21, (i) => _game(i + 1));
      repo.onEnrichWithDetails = (batch) async => batch
          .map((g) => g.copyWith(minPlayers: 2, maxPlayers: 4))
          .toList();

      final future = container.read(gameListProvider.future);
      await Future<void>.delayed(Duration.zero);
      repo.gamesController.add(initial);
      await future;

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repo.enrichCallCount, 2);
      expect(repo.enrichInputs[0], hasLength(20));
      expect(repo.enrichInputs[1], hasLength(1));
      expect(repo.addedGames, hasLength(21));
      expect(repo.addedGames.every((g) => g.isInCollection), isTrue);
    });

    test('보강 중 한 배치 실패해도 다음 배치는 계속 처리한다', () async {
      final sub = container.listen(gameListProvider, (_, __) {});
      addTearDown(sub.close);

      final initial = List.generate(21, (i) => _game(i + 1));
      var invocation = 0;
      repo.onEnrichWithDetails = (batch) async {
        invocation++;
        if (invocation == 1) {
          throw Exception('first batch failed');
        }
        return batch.map((g) => g.copyWith(minPlayers: 2, maxPlayers: 4)).toList();
      };

      final future = container.read(gameListProvider.future);
      await Future<void>.delayed(Duration.zero);
      repo.gamesController.add(initial);
      await future;

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repo.enrichCallCount, 2);
      expect(repo.addedGames, hasLength(1));
      expect(repo.addedGames.single.bggId, 21);
    });

    test('refresh 성공 시 loading 후 data 상태가 된다', () async {
      final sub = container.listen(gameListProvider, (_, __) {});
      addTearDown(sub.close);

      repo.onGetCollection = () async => [_game(42, minPlayers: 2, maxPlayers: 5)];

      final notifier = container.read(gameListProvider.notifier);
      final refreshFuture = notifier.refresh();
      expect(container.read(gameListProvider), isA<AsyncLoading<List<BoardGame>>>());
      await refreshFuture;

      final state = container.read(gameListProvider);
      expect(repo.getCollectionCallCount, 1);
      expect(state, isA<AsyncData<List<BoardGame>>>());
      expect(state.value, hasLength(1));
    });

    test('refresh 실패 시 loading 후 error 상태가 된다', () async {
      final sub = container.listen(gameListProvider, (_, __) {});
      addTearDown(sub.close);

      repo.onGetCollection = () => Future<List<BoardGame>>.error(Exception('refresh fail'));

      final notifier = container.read(gameListProvider.notifier);
      final refreshFuture = notifier.refresh();
      expect(container.read(gameListProvider), isA<AsyncLoading<List<BoardGame>>>());
      await refreshFuture;

      final state = container.read(gameListProvider);
      expect(state, isA<AsyncError<List<BoardGame>>>());
    });
  });
}
