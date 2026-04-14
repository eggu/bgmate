import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/repository/rule_judge_repository.dart';
import 'package:bgmate_flutter/presentation/rule_judge/rule_judge_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rule_judge_notifier_test.mocks.dart';

@GenerateMocks([RuleJudgeRepository])
void main() {
  late MockRuleJudgeRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockRuleJudgeRepository();
    container = ProviderContainer(
      overrides: [ruleJudgeRepositoryProvider.overrideWithValue(mockRepo)],
    );
    addTearDown(container.dispose);
  });

  /// autoDispose 방지를 위해 listen을 시작한다.
  void listen() => container.listen(ruleJudgeProvider, (prev, next) {});

  group('R1 - 초기 build', () {
    test('AsyncData([]) 를 즉시 emit 한다', () async {
      listen();
      final state = await container.read(ruleJudgeProvider.future);
      expect(state, isEmpty);
    });
  });

  group('R2 - judge() 호출 직후', () {
    test('judge() 실행 중 AsyncLoading 을 거친다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => const Stream.empty());
      when(mockRepo.saveHistory(any, any, any)).thenAnswer((_) async {});

      listen();

      // judge() 의 첫 줄이 state = AsyncLoading() 을 동기적으로 실행한다
      // await 없이 호출해서 비동기 시작 전 상태를 캡처한다
      final judgeCall =
          container.read(ruleJudgeProvider.notifier).judge('게임', '질문');

      // 첫 await 이전에 state = AsyncLoading() 이 동기적으로 설정된다
      expect(
        container.read(ruleJudgeProvider),
        isA<AsyncLoading<List<String>>>(),
      );

      await judgeCall;
    });
  });

  group('R3 - 정상 스트리밍 (여러 chunk)', () {
    test('각 chunk 마다 누적된 리스트를 AsyncData 로 emit 한다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => Stream.fromIterable(['A', 'B', 'C']));
      when(mockRepo.saveHistory(any, any, any)).thenAnswer((_) async {});

      listen();

      final dataStates = <List<String>>[];
      container.listen(ruleJudgeProvider, (_, next) {
        // 초기 build() 의 빈 리스트는 제외하고 judge() 결과만 수집
        if (next is AsyncData<List<String>> && next.value.isNotEmpty) {
          dataStates.add(next.value);
        }
      });

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');

      expect(dataStates, [
        ['A'],
        ['A', 'B'],
        ['A', 'B', 'C'],
      ]);
    });
  });

  group('R4 - 스트리밍 완료 시 saveHistory 호출', () {
    test('saveHistory 가 정확히 1회, 올바른 인수로 호출된다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => Stream.fromIterable(['A', 'B', 'C']));
      when(mockRepo.saveHistory(any, any, any)).thenAnswer((_) async {});

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');

      verify(mockRepo.saveHistory('게임', '질문', 'ABC')).called(1);
    });
  });

  group('R5 - 빈 스트림 (0개 chunk)', () {
    test('saveHistory 가 호출되지 않고 state 는 AsyncData([]) 이다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => const Stream.empty());

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');

      verifyNever(mockRepo.saveHistory(any, any, any));

      final state = container.read(ruleJudgeProvider);
      expect(state, isA<AsyncData<List<String>>>());
      expect(state.value, isEmpty);
    });
  });

  group('R6 - 스트리밍 중 에러', () {
    test('AsyncError 로 전이하고 saveHistory 가 호출되지 않는다', () async {
      final error = Exception('스트림 에러');
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => Stream.error(error));

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');

      final state = container.read(ruleJudgeProvider);
      expect(state, isA<AsyncError<List<String>>>());
      expect((state as AsyncError).error, error);
      verifyNever(mockRepo.saveHistory(any, any, any));
    });
  });

  group('R7 - saveHistory 실패 시 state 는 유지', () {
    test('스트리밍 결과(AsyncData)가 유지되고 에러 상태로 전이하지 않는다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => Stream.fromIterable(['A', 'B']));
      when(mockRepo.saveHistory(any, any, any))
          .thenThrow(Exception('DB 에러'));

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');

      final state = container.read(ruleJudgeProvider);
      expect(state, isA<AsyncData<List<String>>>());
      expect(state.value, ['A', 'B']);
    });
  });

  group('R8 - 에러 후 reset()', () {
    test('state 가 AsyncData([]) 로 복귀한다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => Stream.error(Exception('에러')));

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');
      container.read(ruleJudgeProvider.notifier).reset();

      final state = container.read(ruleJudgeProvider);
      expect(state, isA<AsyncData<List<String>>>());
      expect(state.value, isEmpty);
    });
  });

  group('R9 - 정상 완료 후 reset()', () {
    test('state 가 AsyncData([]) 로 복귀한다', () async {
      when(mockRepo.judge(any, any))
          .thenAnswer((_) => Stream.fromIterable(['A']));
      when(mockRepo.saveHistory(any, any, any)).thenAnswer((_) async {});

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임', '질문');
      container.read(ruleJudgeProvider.notifier).reset();

      final state = container.read(ruleJudgeProvider);
      expect(state, isA<AsyncData<List<String>>>());
      expect(state.value, isEmpty);
    });
  });

  group('R10 - judge() 연속 호출', () {
    test('두 번째 호출이 새 스트림으로 이어지고 최종 결과가 올바르다', () async {
      when(mockRepo.judge('게임1', any))
          .thenAnswer((_) => Stream.fromIterable(['X']));
      when(mockRepo.judge('게임2', any))
          .thenAnswer((_) => Stream.fromIterable(['Y', 'Z']));
      when(mockRepo.saveHistory(any, any, any)).thenAnswer((_) async {});

      listen();

      await container.read(ruleJudgeProvider.notifier).judge('게임1', '질문');
      await container.read(ruleJudgeProvider.notifier).judge('게임2', '질문');

      final state = container.read(ruleJudgeProvider);
      expect(state.value, ['Y', 'Z']);
    });
  });
}
