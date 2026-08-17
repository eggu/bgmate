import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/used_price.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameUsedPriceProvider = FutureProvider.autoDispose
    .family<UsedPrice?, BoardGame>((ref, game) async {
      final primaryGame = await _primaryNamedGame(ref, game);
      final originalName = primaryGame.name == game.name
          ? null
          : primaryGame.name;
      return ref
          .watch(usedPriceApiServiceProvider)
          .fetchUsedPrice(game, originalName: originalName);
    });

Future<BoardGame> _primaryNamedGame(Ref ref, BoardGame game) async {
  try {
    return (await ref.watch(gameRepositoryProvider).enrichWithDetails([
          game,
        ])).firstOrNull ??
        game;
  } catch (_) {
    return game;
  }
}
