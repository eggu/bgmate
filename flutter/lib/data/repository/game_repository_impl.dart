import 'package:bgmate_flutter/data/local/game_dao.dart';
import 'package:bgmate_flutter/data/local/game_table_mapper.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GameDao _gameDao;
  final BggRemoteDataSource _bggRemoteDataSource;

  GameRepositoryImpl(this._gameDao, this._bggRemoteDataSource);

  @override
  Future<List<BoardGame>> getCollection() async {
    final entities = await _gameDao.getAll();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<BoardGame>> searchBgg(String query) async {
    return _bggRemoteDataSource.searchGames(query);
  }

  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async {
    if (games.isEmpty) return games;
    final ids = games.map((g) => g.bggId).toList();
    final details = await _bggRemoteDataSource.getThingDetails(ids);
    final detailMap = {for (final d in details) d.bggId: d};
    return games
        .map((g) => detailMap[g.bggId] ?? g)
        .toList();
  }

  @override
  Future<BoardGame?> getGame(int id) async {
    final data = await _gameDao.getGame(id);
    return data?.toDomain();
  }

  @override
  Future<void> addToCollection(BoardGame game) async {
    return await _gameDao.upsert(game.toCompanion());
  }

  @override
  Future<void> removeFromCollection(BoardGame game) async {
    return _gameDao.deleteByBggId(game.bggId);
  }

  @override
  Stream<List<BoardGame>> watchGames() {
    return _gameDao.watchAll().map(
      (entities) => entities.map((e) => e.toDomain()).toList(),
    );
  }
}
