abstract final class AppRoutes {
  static const bggIdParam = 'bggId';
  static const sessionIdParam = 'sessionId';

  static const collection = '/collection';
  static const gameSearch = '/collection/search';
  static const gameDetail = '/collection/detail';
  static const gameDetailPath = '$gameDetail/:$bggIdParam';
  static const ruleJudge = '/rule-judge';
  static const recommend = '/recommend';
  static const score = '/score';
  static const scoreCreate = '/score/create';
  static const scoreCreatePath = '$scoreCreate/:$bggIdParam';
  static const scoreTracker = '/score/tracker';
  static const scoreTrackerPath = '$scoreTracker/:$bggIdParam';
  static const sessionHistory = '/session/history';
  static const sessionHistoryPath = '$sessionHistory/:$sessionIdParam';

  static String gameDetailLocation(int bggId) => '$gameDetail/$bggId';

  static String scoreCreateLocation(int bggId) => '$scoreCreate/$bggId';

  static String scoreTrackerLocation(int bggId) => '$scoreTracker/$bggId';

  static String sessionHistoryLocation(int sessionId) =>
      '$sessionHistory/$sessionId';
}
