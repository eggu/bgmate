import 'dart:developer';

import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rule_judge_notifier.g.dart';

@riverpod
class RuleJudgeNotifier extends StreamNotifier<List<String>> {
  @override
  Stream<List<String>> build() {
    return Stream.value([]);
  }

  Future<void> judge(String gameName, String question) async {
    final repo = ref.read(ruleJudgeRepositoryProvider);
    final chunks = <String>[];
    state = const AsyncValue.loading();
    try {
      await for (final chunk in repo.judge(gameName, question)) {
        chunks.add(chunk);
        state = AsyncData([...chunks]);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      return;
    }

    if (chunks.isNotEmpty) {
      try {
        await repo.saveHistory(gameName, question, chunks.join(''));
      } catch (e, st) {
        log('saveHistory failed: $e', error: e, stackTrace: st);
      }
    }
  }

  void reset() {
    state = const AsyncData([]);
  }
}
