import 'dart:async';

import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';
import 'package:bgmate_flutter/presentation/recommend/recommend_notifier.dart';
import 'package:bgmate_flutter/presentation/recommend/recommend_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fake Notifiers
// ---------------------------------------------------------------------------

/// 기본 Fake: build()는 빈 리스트 반환, recommend() 호출 시 주어진 results로 전환.
class _FakeRecommendNotifier extends RecommendNotifier {
  final List<RecommendResult> _results;

  _FakeRecommendNotifier([this._results = const []]);

  @override
  FutureOr<List<RecommendResult>> build() => _results;

  @override
  Future<void> recommend(
    int playerCount,
    PlayTime playTime,
    Set<Mood> moods,
    bool includeNew,
  ) async {
    state = AsyncData(_results);
  }
}

/// 항상 로딩 상태를 유지하는 Notifier.
class _LoadingRecommendNotifier extends RecommendNotifier {
  @override
  FutureOr<List<RecommendResult>> build() =>
      Completer<List<RecommendResult>>().future;

  @override
  Future<void> recommend(
    int playerCount,
    PlayTime playTime,
    Set<Mood> moods,
    bool includeNew,
  ) async {
    state = const AsyncLoading();
  }
}

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

Widget _buildScreen(RecommendNotifier Function() factory) {
  return ProviderScope(
    overrides: [recommendProvider.overrideWith(factory)],
    child: const MaterialApp(home: RecommendScreen()),
  );
}

/// 인원수, 플레이 시간, 분위기 조건을 각각 1개씩 선택한다.
Future<void> _selectAllConditions(WidgetTester tester) async {
  await tester.tap(find.text('4명'));
  await tester.tap(find.text('30~60분'));
  await tester.tap(find.text('전략'));
  await tester.pump();
}

/// 추천 받기 버튼을 화면에 보이도록 스크롤한 뒤 탭한다.
Future<void> _tapRecommendButton(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(FilledButton));
  await tester.pump();
  await tester.tap(find.byType(FilledButton));
  await tester.pump();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('RecommendScreen', () {
    group('초기 렌더링', () {
      testWidgets('헤더 텍스트가 표시된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        expect(find.text('AI 게임 추천'), findsOneWidget);
      });

      testWidgets('인원수 칩 1~8이 표시된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        for (int i = 1; i <= 8; i++) {
          expect(find.text('$i명'), findsOneWidget);
        }
      });

      testWidgets('플레이 시간 칩 3개가 표시된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        for (final pt in PlayTime.values) {
          expect(find.text(pt.label), findsOneWidget);
        }
      });

      testWidgets('분위기 칩 10개가 표시된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        const moodLabels = [
          '전략', '협동', '추리', '경쟁', '롤플레이',
          '파티', '창의', '순발력', '힐링', '캐주얼',
        ];
        for (final label in moodLabels) {
          expect(find.text(label), findsOneWidget);
        }
      });

      testWidgets('새 게임도 추천받기 Switch가 표시된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        expect(find.text('새 게임도 추천받기'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('초기에 추천 받기 버튼이 비활성화되어 있다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('결과 섹션이 초기에 표시되지 않는다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        expect(find.text('추천 결과'), findsNothing);
      });
    });

    group('FilterChip 선택 상호작용', () {
      testWidgets('인원수 칩을 탭하면 선택 상태가 된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('3명'));
        await tester.pump();

        final chip = tester.widget<FilterChip>(
          find.ancestor(of: find.text('3명'), matching: find.byType(FilterChip)),
        );
        expect(chip.selected, isTrue);
      });

      testWidgets('다른 인원수를 탭하면 이전 선택이 해제되고 새 선택이 활성화된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('2명'));
        await tester.pump();
        await tester.tap(find.text('5명'));
        await tester.pump();

        final chip2 = tester.widget<FilterChip>(
          find.ancestor(of: find.text('2명'), matching: find.byType(FilterChip)),
        );
        final chip5 = tester.widget<FilterChip>(
          find.ancestor(of: find.text('5명'), matching: find.byType(FilterChip)),
        );
        expect(chip2.selected, isFalse);
        expect(chip5.selected, isTrue);
      });

      testWidgets('플레이 시간 칩은 단일 선택된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('30분 이하'));
        await tester.pump();
        await tester.tap(find.text('60분 이상'));
        await tester.pump();

        final shortChip = tester.widget<FilterChip>(
          find.ancestor(
              of: find.text('30분 이하'), matching: find.byType(FilterChip)),
        );
        final longChip = tester.widget<FilterChip>(
          find.ancestor(
              of: find.text('60분 이상'), matching: find.byType(FilterChip)),
        );
        expect(shortChip.selected, isFalse);
        expect(longChip.selected, isTrue);
      });

      testWidgets('분위기 칩은 다중 선택된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('전략'));
        await tester.pump();
        await tester.tap(find.text('파티'));
        await tester.pump();

        final strategyChip = tester.widget<FilterChip>(
          find.ancestor(of: find.text('전략'), matching: find.byType(FilterChip)),
        );
        final partyChip = tester.widget<FilterChip>(
          find.ancestor(of: find.text('파티'), matching: find.byType(FilterChip)),
        );
        expect(strategyChip.selected, isTrue);
        expect(partyChip.selected, isTrue);
      });

      testWidgets('이미 선택된 분위기 칩을 다시 탭하면 해제된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('전략'));
        await tester.pump();
        await tester.tap(find.text('전략'));
        await tester.pump();

        final chip = tester.widget<FilterChip>(
          find.ancestor(of: find.text('전략'), matching: find.byType(FilterChip)),
        );
        expect(chip.selected, isFalse);
      });
    });

    group('추천 받기 버튼 활성화', () {
      testWidgets('세 조건 모두 선택하면 버튼이 활성화된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await _selectAllConditions(tester);

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNotNull);
      });

      testWidgets('인원수만 선택하면 버튼이 비활성화 상태를 유지한다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('4명'));
        await tester.pump();

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('인원수 + 플레이 시간만 선택하면 버튼이 비활성화 상태를 유지한다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.text('4명'));
        await tester.tap(find.text('30~60분'));
        await tester.pump();

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNull);
      });
    });

    group('로딩 상태', () {
      testWidgets('로딩 중에는 버튼 스피너와 "추천 중..." 텍스트가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(_LoadingRecommendNotifier.new),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsWidgets);
        expect(find.text('추천 중...'), findsOneWidget);
      });

      testWidgets('로딩 중에는 버튼이 비활성화된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(_LoadingRecommendNotifier.new),
        );
        await tester.pump();

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('로딩 중에는 결과 로딩 카드가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(_LoadingRecommendNotifier.new),
        );
        await tester.pump();

        expect(find.text('추천 결과'), findsOneWidget);
        expect(find.text('추천 결과를 불러오고 있습니다.'), findsOneWidget);
      });
    });

    group('추천 결과 표시', () {
      final sampleResults = [
        const RecommendResult(
          name: '스플렌더',
          reason: '전략성과 적당한 러닝타임이 잘 맞습니다.',
          isOwned: true,
          bggScore: 7.4,
          difficulty: '중간',
        ),
        const RecommendResult(
          name: '코드네임',
          reason: '파티 분위기와 팀 플레이 감각이 살아 있습니다.',
          isOwned: false,
          bggScore: 7.6,
          difficulty: '쉬움',
        ),
      ];

      testWidgets('추천 버튼 탭 후 결과 카드들이 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(sampleResults)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('추천 결과'), findsOneWidget);
        expect(find.text('스플렌더'), findsOneWidget);
        expect(find.text('코드네임'), findsOneWidget);
      });

      testWidgets('결과 카드에 순위 번호가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(sampleResults)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('보유 게임에 "보유 중" 뱃지가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(sampleResults)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('보유 중'), findsOneWidget);
      });

      testWidgets('새 게임에 "새 게임" 뱃지가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(sampleResults)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('새 게임'), findsOneWidget);
      });

      testWidgets('BGG 평점이 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(sampleResults)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('BGG 평점 7.4'), findsOneWidget);
        expect(find.text('BGG 평점 7.6'), findsOneWidget);
      });

      testWidgets('난이도가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(sampleResults)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('난이도 중간'), findsOneWidget);
        expect(find.text('난이도 쉬움'), findsOneWidget);
      });

      testWidgets('bggScore가 null이면 평점/난이도 항목이 표시되지 않는다', (tester) async {
        final results = [
          const RecommendResult(
            name: '테스트 게임',
            reason: '이유',
            isOwned: false,
          ),
        ];

        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier(results)),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.textContaining('BGG 평점'), findsNothing);
        expect(find.textContaining('난이도'), findsNothing);
      });
    });

    group('빈 결과', () {
      testWidgets('결과가 없으면 빈 결과 카드가 표시된다', (tester) async {
        await tester.pumpWidget(
          _buildScreen(() => _FakeRecommendNotifier()),
        );

        await _selectAllConditions(tester);
        await _tapRecommendButton(tester);

        expect(find.text('추천 결과'), findsOneWidget);
        expect(find.textContaining('추천 결과가 없어요'), findsOneWidget);
      });
    });

    group('새 게임 포함 토글', () {
      testWidgets('Switch 탭 시 설명 텍스트가 변경된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        expect(find.text('내 컬렉션 안에서만 추천'), findsOneWidget);

        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(find.text('보유 게임 우선, 더 잘 맞는 게임도 추천'), findsOneWidget);
      });

      testWidgets('Switch 재탭 시 원래 텍스트로 복원된다', (tester) async {
        await tester.pumpWidget(_buildScreen(_FakeRecommendNotifier.new));

        await tester.tap(find.byType(Switch));
        await tester.pump();
        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(find.text('내 컬렉션 안에서만 추천'), findsOneWidget);
      });
    });
  });
}
