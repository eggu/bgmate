import 'dart:ui';

import 'package:bgmate_flutter/presentation/widgets/feature_action_button.dart';
import 'package:bgmate_flutter/presentation/widgets/info_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('InfoBadge renders icon and label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoBadge(icon: Icons.group_outlined, label: '2-4인'),
        ),
      ),
    );

    expect(find.byIcon(Icons.group_outlined), findsOneWidget);
    expect(find.text('2-4인'), findsOneWidget);
  });

  testWidgets('FeatureActionButton renders title, subtitle, and callback', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FeatureActionButton(
            icon: Icons.casino_outlined,
            title: '점수 시작',
            subtitle: '플레이어를 추가하고 바로 기록',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.casino_outlined), findsOneWidget);
    expect(find.text('점수 시작'), findsOneWidget);
    expect(find.text('플레이어를 추가하고 바로 기록'), findsOneWidget);

    await tester.tap(find.byType(FeatureActionButton));
    expect(tapped, isTrue);
  });

  testWidgets('FeatureActionButton exposes disabled button semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var tapped = false;

    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureActionButton(
              icon: Icons.casino_outlined,
              title: '점수 시작',
              subtitle: '플레이어를 추가하고 바로 기록',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(
        find.semantics.byPredicate((node) {
          final flags = node.getSemanticsData().flagsCollection;
          return flags.isButton && flags.isEnabled == Tristate.isFalse;
        }),
        findsOne,
      );

      await tester.tap(find.byType(FeatureActionButton));
      expect(tapped, isFalse);
    } finally {
      semantics.dispose();
    }
  });
}
