import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
Future<AppDatabase> appDatabase(Ref ref) async {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}

@riverpod
Future<void> seedDatabase(Ref ref) async {
  final database = await ref.watch(appDatabaseProvider.future);
  await database.todoDao.seedDefaults();
}

@riverpod
Future<List<TodoItem>> todoList(Ref ref) async {
  await ref.watch(seedDatabaseProvider.future);
  final database = await ref.watch(appDatabaseProvider.future);
  return database.todoDao.fetchTodos();
}
