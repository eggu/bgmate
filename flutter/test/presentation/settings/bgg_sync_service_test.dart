import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_collection_sync_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_plays_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:bgmate_flutter/data/repository/game_repository_impl.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/model/bgg_collection_sync.dart';
import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_sync_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCollectionApi extends BggCollectionSyncApiService {
  _FakeCollectionApi(this.sync) : super(apiService: BggApiService(token: 't'));

  final BggCollectionSync sync;
  final usernames = <String>[];

  @override
  Future<BggCollectionSync> fetchCollection(String username) async {
    usernames.add(username);
    return sync;
  }
}

class _FakePlaysApi extends BggPlaysApiService {
  _FakePlaysApi(this.detail) : super(apiService: BggApiService(token: 't'));

  final BggPlayDetail detail;
  final usernames = <String>[];

  @override
  Future<BggPlayDetail> fetchPlays({
    required String username,
    required int bggId,
  }) async {
    throw StateError('per-game plays should not be called');
  }

  @override
  Future<BggPlayDetail> fetchUserPlays({required String username}) async {
    usernames.add(username);
    return detail;
  }
}

class _UnusedBggRemoteDataSource implements BggRemoteDataSource {
  @override
  Future<List<BoardGame>> getThingDetails(List<int> ids) async => [];

  @override
  Future<List<BoardGame>> searchGames(String query) async => [];
}

void main() {
  test('BGG sync stores collection, stats, plays, and account', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    var invalidated = false;
    final playsApi = _FakePlaysApi(_playDetailFixture());
    final service = BggSyncService(
      collectionApi: _FakeCollectionApi(_syncFixture()),
      playsApi: playsApi,
      gameRepository: GameRepositoryImpl(
        db.gameDao,
        _UnusedBggRemoteDataSource(),
      ),
      gamePlayStatsDao: db.gamePlayStatsDao,
      sessionDao: db.sessionDao,
      appSettingsDao: db.appSettingsDao,
      invalidateDependents: () => invalidated = true,
    );

    await service.sync(' kurt ');

    expect(await db.appSettingsDao.getValue(bggUsernameSettingKey), 'kurt');
    expect((await db.gameDao.getGame(13))?.name, 'Catan');
    expect((await db.gamePlayStatsDao.getAll()).single.bggPlayCount, 1);
    final sessions = await db.sessionDao.watchSessions().first;
    expect(sessions.single.session.bggPlayId, 9001);
    expect(playsApi.usernames, ['kurt']);
    expect(invalidated, isTrue);
  });

  test('BGG sync preserves existing local game name', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = GameRepositoryImpl(
      db.gameDao,
      _UnusedBggRemoteDataSource(),
    );
    final service = BggSyncService(
      collectionApi: _FakeCollectionApi(_syncFixture()),
      playsApi: _FakePlaysApi(_playDetailFixture()),
      gameRepository: repository,
      gamePlayStatsDao: db.gamePlayStatsDao,
      sessionDao: db.sessionDao,
      appSettingsDao: db.appSettingsDao,
      invalidateDependents: () {},
    );
    await repository.addToCollection(
      const BoardGame(bggId: 13, name: '카탄', yearPublished: 1995),
    );

    await service.sync('kurt');

    expect((await db.gameDao.getGame(13))?.name, '카탄');
  });

  test(
    'BGG sync updates game name to Korean when Korean name is available',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = GameRepositoryImpl(
        db.gameDao,
        _UnusedBggRemoteDataSource(),
      );
      final service = BggSyncService(
        collectionApi: _FakeCollectionApi(_syncFixture(name: '카탄')),
        playsApi: _FakePlaysApi(_playDetailFixture()),
        gameRepository: repository,
        gamePlayStatsDao: db.gamePlayStatsDao,
        sessionDao: db.sessionDao,
        appSettingsDao: db.appSettingsDao,
        invalidateDependents: () {},
      );
      await repository.addToCollection(
        const BoardGame(bggId: 13, name: 'Catan', yearPublished: 1995),
      );

      await service.sync('kurt');

      expect((await db.gameDao.getGame(13))?.name, '카탄');
    },
  );

  test('startup sync runs saved account once', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.appSettingsDao.setValue(bggUsernameSettingKey, 'kurt');
    final collectionApi = _FakeCollectionApi(_syncFixture());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        bggCollectionSyncApiServiceProvider.overrideWithValue(collectionApi),
        bggPlaysApiServiceProvider.overrideWithValue(
          _FakePlaysApi(_playDetailFixture()),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(bggStartupSyncProvider.future);

    expect(collectionApi.usernames, ['kurt']);
  });
}

BggCollectionSync _syncFixture({String name = 'Catan'}) {
  return BggCollectionSync(
    username: 'kurt',
    syncedAt: DateTime(2026, 7, 2),
    games: [
      BggCollectionSyncGame(
        game: BoardGame(
          bggId: 13,
          name: name,
          yearPublished: 1995,
          isInCollection: true,
        ),
        playCount: 1,
        lastPlayedAt: DateTime(2026, 6, 1),
        rating: 7.1,
        isExpansion: false,
      ),
    ],
  );
}

BggPlayDetail _playDetailFixture() {
  return BggPlayDetail(
    username: 'kurt',
    bggId: 13,
    syncedAt: DateTime(2026, 7, 2),
    plays: [
      BggPlaySession(
        bggId: 13,
        playId: 9001,
        date: DateTime(2026, 6, 1),
        quantity: 1,
        lengthMinutes: null,
        incomplete: false,
        noWinStats: false,
        comments: null,
        players: const [],
      ),
    ],
  );
}
