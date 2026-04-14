import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/judge_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'judge_history_notifier.g.dart';

@riverpod
class JudgeHistoryNotifier extends StreamNotifier<List<JudgeHistory>> {
  static const _limit = 5;

  @override
  Stream<List<JudgeHistory>> build() {
    return ref.watch(ruleJudgeRepositoryProvider).watchHistory(_limit);
  }
}
