abstract final class AppRoutes {
  static const bggIdParam = 'bggId';

  static const collection = '/collection';
  static const gameSearch = '/collection/search';
  static const gameDetail = '/collection/detail';
  static const gameDetailPath = '$gameDetail/:$bggIdParam';
  static const ruleJudge = '/rule-judge';
  static const recommend = '/recommend';
  static const score = '/score';
  static const scoreCreate = '/score/create';
  static const scoreCreatePath = '$scoreCreate/:$bggIdParam';


  static String gameDetailLocation(int bggId) => '$gameDetail/$bggId';
  static String scoreCreateLocation(int bggId) => '$scoreCreate/$bggId';

}
