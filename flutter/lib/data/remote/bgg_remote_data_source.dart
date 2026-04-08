import 'package:bgmate_flutter/domain/model/board_game.dart';

abstract interface class BggRemoteDataSource {
  Future<List<BoardGame>> searchGames(String query);

  Future<List<BoardGame>> getThingDetails(List<int> ids);
}
