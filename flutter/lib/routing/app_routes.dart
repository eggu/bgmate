abstract final class AppRoutes {
  static const bggIdParam = 'bggId';
  static const sessionIdParam = 'sessionId';

  static const collection = '/collection';
  static const accountSettings = '$collection/account';
  static const gameSearch = '$collection/search';
  static const gameDetail = '$collection/detail';
  static const gameDetailPath = '$gameDetail/:$bggIdParam';
  static const ruleJudge = '/rule-judge';
  static const recommend = '/recommend';
  static const session = '/session';
  static const sessionCreate = '$session/create';
  static const scoreCreatePath = '$sessionCreate/:$bggIdParam';
  static const sessionTracker = '$session/tracker';
  static const scoreTrackerPath = '$sessionTracker/:$bggIdParam';
  static const sessionHistory = '$session/history';
  static const sessionHistoryPath = 'history/:$sessionIdParam';

  static String gameDetailLocation(int bggId) => '$gameDetail/$bggId';

  static String scoreCreateLocation(int bggId) => '$sessionCreate/$bggId';

  static String scoreTrackerLocation(int bggId) => '$sessionTracker/$bggId';

  static String sessionHistoryLocation(int sessionId) =>
      '$sessionHistory/$sessionId';
}
