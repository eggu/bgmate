import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';

abstract interface class RecommendRepository {
  Future<List<RecommendResult>> recommend({
    required int playerCount,
    required int playTimeMinutes,
    required List<BoardGame> collection,
  });
}
