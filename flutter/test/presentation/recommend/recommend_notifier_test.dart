import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';
import 'package:bgmate_flutter/domain/repository/recommend_repository.dart';
import 'package:bgmate_flutter/presentation/recommend/recommend_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRecommendRepository implements RecommendRepository {
  int callCount = 0;
  RecommendCondition? lastCondition;
  bool? lastIncludeNew;
  List<BoardGame>? lastOwnedGames;

  Future<List<RecommendResult>> Function({
    required RecommendCondition condition,
    required bool includeNew,
    required List<BoardGame> ownedGames,
  })? onRecommend;

  @override
  Future<List<RecommendResult>> recommend({
    required RecommendCondition condition,
    required bool includeNew,
    required List<BoardGame> ownedGames,
  }) async {
    callCount++;
    lastCondition = condition;
    lastIncludeNew = includeNew;
    lastOwnedGames = ownedGames;

    final handler = onRecommend;
    if (handler == null) return [];
    return handler(
      condition: condition,
      includeNew: includeNew,
      ownedGames: ownedGames,
    );
  }
}

void main() {
  late _FakeRecommendRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = _FakeRecommendRepository();
    container = ProviderContainer(
      overrides: [recommendRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  void listen() => container.listen(recommendProvider, (_, __) {});

  group('RecommendNotifier', () {
    test('초기 build는 빈 리스트를 반환한다', () async {
      listen();

      final state = await container.read(recommendProvider.future);

      expect(state, isEmpty);
    });

    test('recommend 호출 직후 AsyncLoading을 거쳐 성공 시 AsyncData로 전이한다', () async {
      final completer = Completer<List<RecommendResult>>();
      final expected = [
        const RecommendResult(
          name: 'Catan',
          reason: '입문자에게 좋음',
          isOwned: false,
          bggScore: 7.2,
          difficulty: 'easy',
        ),
      ];

      repo.onRecommend = ({
        required condition,
        required includeNew,
        required ownedGames,
      }) => completer.future;

      listen();

      final recommendCall = container
          .read(recommendProvider.notifier)
          .recommend(4, PlayTime.medium, {Mood.strategy, Mood.party}, true);

      expect(container.read(recommendProvider), isA<AsyncLoading<List<RecommendResult>>>());

      completer.complete(expected);
      await recommendCall;

      final state = container.read(recommendProvider);
      expect(state, isA<AsyncData<List<RecommendResult>>>());
      expect(state.value, expected);
    });

    test('recommend는 condition/includeNew/ownedGames를 정확히 전달한다', () async {
      repo.onRecommend = ({
        required condition,
        required includeNew,
        required ownedGames,
      }) async => [];

      listen();

      await container
          .read(recommendProvider.notifier)
          .recommend(3, PlayTime.long, {Mood.cooperative, Mood.relaxed}, false);

      expect(repo.callCount, 1);
      expect(repo.lastIncludeNew, false);
      expect(repo.lastOwnedGames, isEmpty);
      expect(repo.lastCondition?.playerCount, 3);
      expect(repo.lastCondition?.playTimeMinutes, PlayTime.long);
      expect(repo.lastCondition?.moods, {Mood.cooperative, Mood.relaxed});
    });

    test('repository 예외 발생 시 AsyncError로 전이한다', () async {
      final error = Exception('temporary unavailable');
      repo.onRecommend = ({
        required condition,
        required includeNew,
        required ownedGames,
      }) => Future<List<RecommendResult>>.error(error);

      listen();

      await container
          .read(recommendProvider.notifier)
          .recommend(2, PlayTime.short, {Mood.casual}, true);

      final state = container.read(recommendProvider);
      expect(state, isA<AsyncError<List<RecommendResult>>>());
      expect((state as AsyncError<List<RecommendResult>>).error, error);
    });
  });
}
