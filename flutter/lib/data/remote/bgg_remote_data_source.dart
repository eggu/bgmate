import 'package:bgmate_flutter/domain/model/board_game.dart';

abstract interface class BggRemoteDataSource {
  Future<List<BoardGame>> searchGames(String query);
}
