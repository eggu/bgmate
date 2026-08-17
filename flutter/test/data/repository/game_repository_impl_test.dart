import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:bgmate_flutter/data/repository/game_repository_impl.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedBggRemoteDataSource implements BggRemoteDataSource {
  @override
  Future<List<BoardGame>> getThingDetails(List<int> ids) async => [];

  @override
  Future<List<BoardGame>> searchGames(String query) async => [];
}

void main() {
  test(
    'addToCollection preserves Korean name while refreshing details',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = GameRepositoryImpl(
        db.gameDao,
        _UnusedBggRemoteDataSource(),
      );

      await repository.addToCollection(
        const BoardGame(bggId: 123, name: '비뉴스 디럭스 에디션', yearPublished: 2025),
      );

      await repository.addToCollection(
        const BoardGame(
          bggId: 123,
          name: 'Venus: Deluxe Edition',
          yearPublished: 2025,
          thumbnail: 'thumb',
          minPlayers: 1,
          maxPlayers: 4,
          playingTime: 40,
          description: 'desc',
        ),
      );

      final game = await repository.getGame(123);

      expect(game?.name, '비뉴스 디럭스 에디션');
      expect(game?.thumbnail, 'thumb');
      expect(game?.minPlayers, 1);
      expect(game?.maxPlayers, 4);
      expect(game?.playingTime, 40);
      expect(game?.description, 'desc');
    },
  );

  test(
    'addToCollection updates English name when no Korean name exists',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = GameRepositoryImpl(
        db.gameDao,
        _UnusedBggRemoteDataSource(),
      );

      await repository.addToCollection(
        const BoardGame(bggId: 456, name: 'Old English', yearPublished: 2025),
      );

      await repository.addToCollection(
        const BoardGame(bggId: 456, name: 'New English', yearPublished: 2025),
      );

      expect((await repository.getGame(456))?.name, 'New English');
    },
  );
}
