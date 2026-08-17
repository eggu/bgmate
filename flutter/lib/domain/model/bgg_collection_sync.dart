import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/game_play_stats.dart';

class BggCollectionSync {
  final String username;
  final List<BggCollectionSyncGame> games;
  final DateTime syncedAt;

  const BggCollectionSync({
    required this.username,
    required this.games,
    required this.syncedAt,
  });

  factory BggCollectionSync.fromApiJson(Map<String, dynamic> json) {
    return BggCollectionSync(
      username: '${json['username'] ?? ''}',
      syncedAt: DateTime.parse('${json['syncedAt']}'),
      games: [
        for (final item in (json['games'] as List? ?? const []))
          if (item is Map<String, dynamic>)
            BggCollectionSyncGame.fromApiJson(item),
      ],
    );
  }
}

class BggCollectionSyncGame {
  final BoardGame game;
  final int playCount;
  final DateTime? lastPlayedAt;
  final double? rating;
  final bool isExpansion;

  const BggCollectionSyncGame({
    required this.game,
    required this.playCount,
    required this.lastPlayedAt,
    required this.rating,
    required this.isExpansion,
  });

  GamePlayStats toStats() => GamePlayStats(
    bggId: game.bggId,
    playCount: playCount,
    lastPlayedAt: lastPlayedAt,
    rating: rating,
    isExpansion: isExpansion,
  );

  factory BggCollectionSyncGame.fromApiJson(Map<String, dynamic> json) {
    return BggCollectionSyncGame(
      game: BoardGame(
        bggId: _asInt(json['bggId']),
        name: '${json['name'] ?? ''}',
        yearPublished: _asInt(json['yearPublished']),
        thumbnail: '${json['thumbnail'] ?? ''}',
        isInCollection: json['owned'] != false,
      ),
      playCount: _asInt(json['playCount']),
      lastPlayedAt: _asDate(json['lastPlayedAt']),
      rating: _asDouble(json['rating']),
      isExpansion: json['isExpansion'] == true,
    );
  }
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

DateTime? _asDate(Object? value) {
  if (value == null) return null;
  final parsed = DateTime.tryParse('$value');
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}
