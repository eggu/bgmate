import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';

abstract interface class RecommendRepository {
  Future<List<RecommendResult>> recommend({
    required RecommendCondition condition,
    required bool includeNew,
    required List<BoardGame> ownedGames,
  });
}
