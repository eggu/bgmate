abstract final class AppRoutes {
  static const bggIdParam = 'bggId';
  static const sessionIdParam = 'sessionId';
  static const gameNameQueryParam = 'gameName';

  static const home = '/';
  static const collection = '/collection';
  static const gameSearch = '$collection/search';
  static const gameDetail = '$collection/detail';
  static const gameDetailPath = '$gameDetail/:$bggIdParam';
  static const ruleJudge = '/rule-judge';
  static const recommend = '/recommend';
  static const saleRecommend = '/sale-recommend';
  static const session = '/session';
  static const settings = '/settings';
  static const sessionCreate = '$session/create';
  static const scoreCreatePath = '$sessionCreate/:$bggIdParam';
  static const sessionTracker = '$session/tracker';
  static const scoreTrackerPath = '$sessionTracker/:$bggIdParam';
  static const sessionHistory = '$session/history';
  static const sessionHistoryPath = 'history/:$sessionIdParam';
  static const bggPlayStatsDetailPath = 'bgg/:$bggIdParam';

  static String gameDetailLocation(int bggId) => '$gameDetail/$bggId';

  static String ruleJudgeLocation({String? gameName}) {
    final trimmed = gameName?.trim();
    if (trimmed == null || trimmed.isEmpty) return ruleJudge;
    return Uri(
      path: ruleJudge,
      queryParameters: {gameNameQueryParam: trimmed},
    ).toString();
  }

  static String scoreCreateLocation(int bggId) => '$sessionCreate/$bggId';

  static String scoreTrackerLocation(int bggId) => '$sessionTracker/$bggId';

  static String sessionHistoryLocation(int sessionId) =>
      '$sessionHistory/$sessionId';

  static String bggPlayStatsDetailLocation(int bggId) => '$session/bgg/$bggId';
}
