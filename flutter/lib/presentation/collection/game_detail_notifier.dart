import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_detail_notifier.g.dart';

@riverpod
Future<BoardGame?> gameDetail(Ref ref, int bggId) async {
  return ref.watch(gameRepositoryProvider).getGame(bggId);
}
