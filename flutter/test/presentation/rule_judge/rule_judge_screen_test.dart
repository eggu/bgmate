import 'dart:async';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/judge_history.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/rule_judge/judge_history_notifier.dart';
import 'package:bgmate_flutter/presentation/rule_judge/rule_judge_notifier.dart';
import 'package:bgmate_flutter/presentation/rule_judge/rule_judge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGameRepository implements GameRepository {
  @override
  Future<void> addToCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async => [];

  @override
  Future<BoardGame?> getGame(int id) async => null;

  @override
  Future<List<BoardGame>> getCollection() async => [];

  @override
  Future<void> removeFromCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> searchBgg(String query) async => [];

  @override
  Stream<List<BoardGame>> watchGames() => Stream.value([]);
}

class _FakeJudgeHistoryNotifier extends JudgeHistoryNotifier {
  @override
  Stream<List<JudgeHistory>> build() => Stream.value([]);
}

class _ErrorRuleJudgeNotifier extends RuleJudgeNotifier {
  @override
  Stream<List<String>> build() => Stream.value([]);

  @override
  Future<void> judge(String gameName, String question) async {
    state = AsyncError(
      const RuleJudgeTemporaryUnavailableException(),
      StackTrace.current,
    );
  }
}

Widget _buildScreen({String? initialGameName}) {
  return ProviderScope(
    overrides: [
      gameRepositoryProvider.overrideWithValue(_FakeGameRepository()),
      judgeHistoryProvider.overrideWith(_FakeJudgeHistoryNotifier.new),
      ruleJudgeProvider.overrideWith(_ErrorRuleJudgeNotifier.new),
    ],
    child: MaterialApp(home: RuleJudgeScreen(initialGameName: initialGameName)),
  );
}

void main() {
  group('RuleJudgeScreen', () {
    testWidgets('초기 게임 이름이 있으면 게임 이름 입력란에 채운다', (tester) async {
      await tester.pumpWidget(_buildScreen(initialGameName: 'Catan'));
      await tester.pump();

      expect(find.text('Catan'), findsOneWidget);
    });

    testWidgets('초기 게임 이름이 바뀌면 입력란도 갱신한다', (tester) async {
      await tester.pumpWidget(_buildScreen(initialGameName: 'Catan'));
      await tester.pump();

      await tester.pumpWidget(_buildScreen(initialGameName: 'Azul'));
      await tester.pump();

      expect(find.text('Azul'), findsOneWidget);
      expect(find.text('Catan'), findsNothing);
    });

    testWidgets('503 에러면 잠시 후 다시 시도 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), '카탄');
      await tester.enterText(find.byType(TextField).at(1), '동점일 때 도적 처리 순서는?');
      await tester.pump();

      await tester.tap(find.text('판정 요청'));
      await tester.pump();

      expect(
        find.text('요청이 많아 규칙 판정 서버가 잠시 불안정해요. 잠시 후 다시 시도해 주세요.'),
        findsOneWidget,
      );
    });
  });
}
