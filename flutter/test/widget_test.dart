import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:bgmate_flutter/data/local/app_database.dart';

void main() {
  test('seeds local todos', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.todoDao.seedDefaults();
    final todos = await database.todoDao.fetchTodos();

    expect(todos, isNotEmpty);
    expect(
      todos.any((item) => item.title == 'Set up Drift for local storage'),
      isTrue,
    );
  });
}
