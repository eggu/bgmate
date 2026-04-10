import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_history_detail_notifier.g.dart';

@riverpod
Future<SessionHistory?> historyDetail(Ref ref, int sessionId) async {
  return ref.watch(sessionRepositoryProvider).getSession(sessionId);
}