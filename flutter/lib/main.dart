import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bgmate_flutter/data/local/database_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'BGMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BGMate Local DB'),
      ),
      body: todos.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = items[index];
            return CheckboxListTile(
              value: item.isDone,
              contentPadding: EdgeInsets.zero,
              title: Text(item.title),
              subtitle: Text('Created: ${item.createdAt.toLocal()}'),
              onChanged: (_) async {
                final database = await ref.read(appDatabaseProvider.future);
                await database.todoDao.toggleTodo(item);
                ref.invalidate(todoListProvider);
              },
            );
          },
          separatorBuilder: (_, _) => const Divider(),
          itemCount: items.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Database error: $error'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final database = await ref.read(appDatabaseProvider.future);
          await database.todoDao.addTodo(
            'New task ${DateTime.now().toIso8601String()}',
          );
          ref.invalidate(todoListProvider);
        },
        tooltip: 'Add todo',
        child: const Icon(Icons.playlist_add),
      ),
    );
  }
}
