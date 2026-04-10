import 'package:bgmate_flutter/domain/model/judge_history.dart';

abstract interface class RuleJudgeRepository {
  Stream<String> judge(String gameName, String question);

  Future<void> saveHistory(String gameName, String question, String answer);

  Stream<List<JudgeHistory>> watchHistory(int limit);
}
