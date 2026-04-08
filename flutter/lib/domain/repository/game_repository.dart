import 'package:bgmate_flutter/domain/model/board_game.dart';

abstract interface class GameRepository {
  Future<List<BoardGame>> getCollection();

  Stream<List<BoardGame>> watchGames();


  Future<List<BoardGame>> searchBgg(String query);

  Future<BoardGame?> getGame(int id);

  Future<void> addToCollection(BoardGame game);

  Future<void> removeFromCollection(BoardGame game);
}
