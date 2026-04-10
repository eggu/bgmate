import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/game_dao.dart';
import 'package:bgmate_flutter/data/local/judge_history_dao.dart';
import 'package:bgmate_flutter/data/local/session_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
GameDao gameDao(Ref ref) => ref.watch(appDatabaseProvider).gameDao;

@Riverpod(keepAlive: true)
SessionDao sessionDao(Ref ref) => ref.watch(appDatabaseProvider).sessionDao;

@Riverpod(keepAlive: true)
JudgeHistoryDao judgeHistoryDao(Ref ref) =>
    ref.watch(appDatabaseProvider).judgeHistoryDao;