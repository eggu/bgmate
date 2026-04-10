abstract interface class RuleJudgeRepository {
  Stream<String> judge(String gameName, String question);
}
