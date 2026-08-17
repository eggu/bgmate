import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_collection_sync_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_plays_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:bgmate_flutter/data/repository/game_repository_impl.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_sync_service.dart';
import 'package:bgmate_flutter/presentation/settings/settings_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedBggRemoteDataSource implements BggRemoteDataSource {
  @override
  Future<List<BoardGame>> getThingDetails(List<int> ids) async => [];

  @override
  Future<List<BoardGame>> searchGames(String query) async => [];
}

class _FakeBggSyncService extends BggSyncService {
  _FakeBggSyncService({required AppDatabase db, required this.onSync})
    : super(
        collectionApi: BggCollectionSyncApiService(
          apiService: BggApiService(token: 't'),
        ),
        playsApi: BggPlaysApiService(apiService: BggApiService(token: 't')),
        gameRepository: GameRepositoryImpl(
          db.gameDao,
          _UnusedBggRemoteDataSource(),
        ),
        gamePlayStatsDao: db.gamePlayStatsDao,
        sessionDao: db.sessionDao,
        appSettingsDao: db.appSettingsDao,
        invalidateDependents: () {},
      );

  final Future<void> Function(String username) onSync;

  @override
  Future<void> sync(String username) => onSync(username);
}

void main() {
  testWidgets('연결된 BGG 계정도 다시 동기화할 수 있다', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.appSettingsDao.setValue(bggUsernameSettingKey, 'kurt');
    String? syncedUsername;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          bggCollectionSyncApiServiceProvider.overrideWithValue(
            BggCollectionSyncApiService(apiService: BggApiService(token: 't')),
          ),
          bggSyncServiceProvider.overrideWithValue(
            _FakeBggSyncService(
              db: db,
              onSync: (username) async => syncedUsername = username,
            ),
          ),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('동기화 중인 계정'), findsOneWidget);
    expect(find.text('kurt'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, '동기화하기'));
    await tester.pump();

    expect(syncedUsername, 'kurt');
  });
}
