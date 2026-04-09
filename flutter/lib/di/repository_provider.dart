import 'package:bgmate_flutter/data/repository/game_repository_impl.dart';
import 'package:bgmate_flutter/data/repository/score_repository_impl.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/domain/repository/score_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_provider.g.dart';

@Riverpod(keepAlive: true)
GameRepository gameRepository(Ref ref) => GameRepositoryImpl(
  ref.watch(gameDaoProvider),
  ref.watch(bggRemoteDataSourceProvider),
);

@Riverpod(keepAlive: true)
ScoreRepository scoreRepository(Ref ref) =>
    ScoreRepositoryImpl(ref.watch(sessionDaoProvider));
