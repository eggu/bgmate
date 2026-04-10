import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_history_notifier.g.dart';

@riverpod
class SessionHistoryNotifier extends _$SessionHistoryNotifier {
  @override
  Stream<List<SessionHistory>> build() {
    final repo = ref.watch(sessionRepositoryProvider);
    return repo.watchSessions();
  }
}
