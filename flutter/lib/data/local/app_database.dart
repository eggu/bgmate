import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  final int id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  factory TodoItem.fromDrift(Todo row) {
    return TodoItem(
      id: row.id,
      title: row.title,
      isDone: row.isDone,
      createdAt: row.createdAt,
    );
  }
}

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Todos], daos: [TodoDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'bgmate.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Todos])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(super.db);

  Future<void> seedDefaults() async {
    final countExpression = todos.id.count();
    final countQuery = selectOnly(todos)..addColumns([countExpression]);
    final count = await countQuery.map((row) {
      return row.read(countExpression) ?? 0;
    }).getSingle();

    if (count > 0) {
      return;
    }

    await batch((batch) {
      batch.insertAll(
        todos,
        [
          TodosCompanion.insert(title: 'Set up Drift for local storage'),
          TodosCompanion.insert(title: 'Keep Riverpod generator for providers'),
          TodosCompanion.insert(title: 'Use Drift and Riverpod together'),
        ],
      );
    });
  }

  Future<List<TodoItem>> fetchTodos() async {
    final rows = await (select(todos)
          ..orderBy([
            (table) => OrderingTerm.desc(table.createdAt),
          ]))
        .get();
    return rows.map(TodoItem.fromDrift).toList();
  }

  Future<int> addTodo(String title) {
    return into(todos).insert(TodosCompanion.insert(title: title));
  }

  Future<int> toggleTodo(TodoItem item) {
    return (update(todos)..where((table) => table.id.equals(item.id))).write(
      TodosCompanion(
        isDone: Value(!item.isDone),
      ),
    );
  }
}
