import 'package:bgmate_flutter/domain/model/judge_result.dart';

abstract interface class RuleJudgeRepository {
  Stream<String> judge(String question);

  Future<List<JudgeResult>> getHistory();

  Future<void> saveResult(JudgeResult result);
}
