import 'dart:developer' as developer;

import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/data/local/app_settings_dao.dart';
import 'package:bgmate_flutter/data/local/game_play_stats_dao.dart';
import 'package:bgmate_flutter/data/local/session_dao.dart';
import 'package:bgmate_flutter/data/remote/bgg_collection_sync_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_plays_api_service.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/sale/sale_recommend_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_detail_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_stats_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_notifier.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_play_import.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bggSyncServiceProvider = Provider<BggSyncService>(
  (ref) => BggSyncService(
    collectionApi: ref.watch(bggCollectionSyncApiServiceProvider),
    playsApi: ref.watch(bggPlaysApiServiceProvider),
    gameRepository: ref.watch(gameRepositoryProvider),
    gamePlayStatsDao: ref.watch(gamePlayStatsDaoProvider),
    sessionDao: ref.watch(sessionDaoProvider),
    appSettingsDao: ref.watch(appSettingsDaoProvider),
    invalidateDependents: () {
      ref.invalidate(gameListProvider);
      ref.invalidate(sessionHistoryProvider);
      ref.invalidate(bggPlayStatsProvider);
      ref.invalidate(bggPlayDetailProvider);
      ref.invalidate(saleCandidatesProvider);
    },
  ),
);

final bggStartupSyncProvider = FutureProvider<void>((ref) async {
  final username = await ref
      .watch(appSettingsDaoProvider)
      .getValue(bggUsernameSettingKey);
  if (username == null || username.trim().isEmpty) return;
  try {
    await ref.watch(bggSyncServiceProvider).sync(username);
  } catch (error, stackTrace) {
    developer.log(
      'BGG startup sync failed',
      name: 'bgmate.bggSync',
      error: error,
      stackTrace: stackTrace,
    );
    rethrow;
  }
});

class BggSyncService {
  final BggCollectionSyncApiService _collectionApi;
  final BggPlaysApiService _playsApi;
  final GameRepository _gameRepository;
  final GamePlayStatsDao _gamePlayStatsDao;
  final SessionDao _sessionDao;
  final AppSettingsDao _appSettingsDao;
  final void Function() _invalidateDependents;

  const BggSyncService({
    required BggCollectionSyncApiService collectionApi,
    required BggPlaysApiService playsApi,
    required GameRepository gameRepository,
    required GamePlayStatsDao gamePlayStatsDao,
    required SessionDao sessionDao,
    required AppSettingsDao appSettingsDao,
    required void Function() invalidateDependents,
  }) : _collectionApi = collectionApi,
       _playsApi = playsApi,
       _gameRepository = gameRepository,
       _gamePlayStatsDao = gamePlayStatsDao,
       _sessionDao = sessionDao,
       _appSettingsDao = appSettingsDao,
       _invalidateDependents = invalidateDependents;

  Future<void> sync(String username) async {
    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty) {
      throw StateError('BGG username is empty.');
    }

    final sync = await _collectionApi.fetchCollection(trimmedUsername);
    final ownedGames = sync.games.where((g) => g.game.isInCollection).toList();
    final ownedBggIds = {for (final item in ownedGames) item.game.bggId};

    for (final item in ownedGames) {
      await _gameRepository.addToCollection(
        item.game.copyWith(isInCollection: true),
      );
    }

    final userPlayDetail = await _playsApi.fetchUserPlays(
      username: trimmedUsername,
    );
    final lastPlayedByBggId = <int, DateTime>{};
    for (final play in userPlayDetail.plays) {
      final bggId = play.bggId;
      if (bggId == null || !ownedBggIds.contains(bggId)) continue;
      final previous = lastPlayedByBggId[bggId];
      if (previous == null || play.date.isAfter(previous)) {
        lastPlayedByBggId[bggId] = play.date;
      }
    }

    await _gamePlayStatsDao.upsertAll(
      ownedGames.map(
        (item) => GamePlayStatsTableCompanion(
          bggId: Value(item.game.bggId),
          bggPlayCount: Value(item.playCount),
          bggLastPlayedAt: Value(
            lastPlayedByBggId[item.game.bggId] ?? item.lastPlayedAt,
          ),
          bggRating: Value(item.rating),
          bggIsExpansion: Value(item.isExpansion),
          syncedAt: Value(sync.syncedAt),
        ),
      ),
    );

    final bggSessionImports = buildBggSessionImports(
      userPlayDetail,
    ).where((item) => ownedBggIds.contains(item.bggId)).toList();
    await _sessionDao.replaceBggSyncedSessions(bggSessionImports);
    await _appSettingsDao.setValue(bggUsernameSettingKey, trimmedUsername);
    _invalidateDependents();
  }

  void invalidateDependents() => _invalidateDependents();
}
