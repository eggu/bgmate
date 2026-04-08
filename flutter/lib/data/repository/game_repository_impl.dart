import 'package:bgmate_flutter/data/local/game_dao.dart';
import 'package:bgmate_flutter/data/local/game_table_mapper.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GameDao _gameDao;

  GameRepositoryImpl(this._gameDao);

  @override
  Future<List<BoardGame>> getCollection() async {
    final entities = await _gameDao.getAll();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<BoardGame>> searchBgg(String query) async {
    return List<BoardGame>.empty();
  }

  @override
  Future<BoardGame> getGame(String id) {
    throw Exception("");
  }

  @override
  Future<void> addToCollection(BoardGame game) async {
    return await _gameDao.upsert(game.toCompanion());
  }

  @override
  Future<void> removeFromCollection(BoardGame game) async {
    return _gameDao.deleteByBggId(game.bggId);
  }
}
