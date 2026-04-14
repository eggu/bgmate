import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/judge_history.dart';
import 'package:bgmate_flutter/domain/repository/rule_judge_repository.dart';
import 'package:bgmate_flutter/presentation/rule_judge/judge_history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'judge_history_notifier_test.mocks.dart';

/// 모든 provider 상태 전이를 기록하는 옵저버
base class _StateObserver extends ProviderObserver {
  final List<Object?> updates = [];

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    updates.add(newValue);
  }
}

@GenerateMocks([RuleJudgeRepository])
void main() {
  late MockRuleJudgeRepository mockRepo;
  late StreamController<List<JudgeHistory>> controller;
  late ProviderContainer container;

  JudgeHistory history(int id, {String name = '게임'}) => JudgeHistory(
        id: id,
        gameName: name,
        question: '질문',
        answer: '답변',
        askedAt: DateTime(2026, 4, 14),
      );

  setUp(() {
    mockRepo = MockRuleJudgeRepository();
    controller = StreamController<List<JudgeHistory>>();

    when(mockRepo.watchHistory(any)).thenAnswer((_) => controller.stream);
    when(mockRepo.judge(any, any)).thenAnswer((_) => const Stream.empty());
    when(mockRepo.saveHistory(any, any, any)).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [ruleJudgeRepositoryProvider.overrideWithValue(mockRepo)],
    );
    addTearDown(container.dispose);
  });

  tearDown(() async {
    if (!controller.isClosed) await controller.close();
  });

  /// autoDispose 방지를 위해 listen을 시작한다.
  void listen() => container.listen(judgeHistoryProvider, (_, __) {});

  group('H1 - 초기 build, 빈 리스트 emit', () {
    test('AsyncData([]) 를 반환한다', () async {
      listen();
      controller.add([]);

      await Future<void>.delayed(Duration.zero);

      final state = container.read(judgeHistoryProvider);
      expect(state, isA<AsyncData<List<JudgeHistory>>>());
      expect(state.value, isEmpty);
    });
  });

  group('H2 - N개 항목 emit', () {
    test('AsyncData 에 N개 항목이 포함된다', () async {
      listen();
      final items = [history(1), history(2), history(3)];
      controller.add(items);

      await Future<void>.delayed(Duration.zero);

      final state = container.read(judgeHistoryProvider);
      expect(state.value, items);
    });
  });

  group('H3 - 스트림 새 값 emit (실시간 watch)', () {
    test('두 번째 emit 으로 notifier 값이 갱신된다', () async {
      listen();

      controller.add([history(1)]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(judgeHistoryProvider).value, hasLength(1));

      controller.add([history(1), history(2)]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(judgeHistoryProvider).value, hasLength(2));
    });
  });

  group('H4 - repo 스트림 에러 emit', () {
    test('AsyncError 로 전이한다', () async {
      final error = Exception('DB 에러');

      // retry: null 반환 → retry 비활성화. 이렇게 해야 에러 이후 AsyncLoading 으로
      // 돌아가지 않고 AsyncError 상태가 유지된다.
      final noRetryContainer = ProviderContainer(
        overrides: [ruleJudgeRepositoryProvider.overrideWithValue(mockRepo)],
        retry: (retryCount, error) => null,
      );
      addTearDown(noRetryContainer.dispose);

      noRetryContainer.listen(judgeHistoryProvider, (prev, next) {});

      controller.addError(error);
      await pumpEventQueue();

      final state = noRetryContainer.read(judgeHistoryProvider);
      expect(state, isA<AsyncError<List<JudgeHistory>>>());
      expect((state as AsyncError).error, error);
    });
  });

  group('H5 - limit 검증', () {
    test('watchHistory 가 limit=5 로 정확히 1회 호출된다', () {
      listen();
      verify(mockRepo.watchHistory(5)).called(1);
    });
  });

  group('H6 - repo 스트림 close', () {
    test('스트림 종료 후 마지막 값이 유지되고 에러가 없다', () async {
      listen();
      final items = [history(1)];
      controller.add(items);
      await Future<void>.delayed(Duration.zero);

      await controller.close();
      await Future<void>.delayed(Duration.zero);

      // 스트림 완료 후에도 마지막 AsyncData 값이 유지되어야 한다
      final state = container.read(judgeHistoryProvider);
      expect(state, isA<AsyncData<List<JudgeHistory>>>());
      expect(state.value, items);
    });
  });
}
