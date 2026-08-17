class BggPlayDetail {
  final String username;
  final int bggId;
  final List<BggPlaySession> plays;
  final DateTime syncedAt;

  const BggPlayDetail({
    required this.username,
    required this.bggId,
    required this.plays,
    required this.syncedAt,
  });

  factory BggPlayDetail.fromApiJson(Map<String, dynamic> json) {
    return BggPlayDetail(
      username: '${json['username'] ?? ''}',
      bggId: _asInt(json['bggId']),
      syncedAt: DateTime.parse('${json['syncedAt']}'),
      plays: [
        for (final item in (json['plays'] as List? ?? const []))
          if (item is Map<String, dynamic>) BggPlaySession.fromApiJson(item),
      ],
    );
  }
}

class BggPlaySession {
  final int? bggId;
  final int playId;
  final DateTime date;
  final int quantity;
  final int? lengthMinutes;
  final bool incomplete;
  final bool noWinStats;
  final String? comments;
  final List<BggPlayPlayer> players;

  const BggPlaySession({
    this.bggId,
    required this.playId,
    required this.date,
    required this.quantity,
    required this.lengthMinutes,
    required this.incomplete,
    required this.noWinStats,
    required this.comments,
    required this.players,
  });

  factory BggPlaySession.fromApiJson(Map<String, dynamic> json) {
    return BggPlaySession(
      bggId: _asNullableInt(json['bggId']),
      playId: _asInt(json['playId']),
      date: _asDate(json['date']) ?? DateTime(0),
      quantity: _asInt(json['quantity'], fallback: 1),
      lengthMinutes: _asNullableInt(json['length']),
      incomplete: json['incomplete'] == true,
      noWinStats: json['noWinStats'] == true,
      comments: _asNullableString(json['comments']),
      players: [
        for (final item in (json['players'] as List? ?? const []))
          if (item is Map<String, dynamic>) BggPlayPlayer.fromApiJson(item),
      ],
    );
  }
}

class BggPlayPlayer {
  final String name;
  final String? username;
  final int? userId;
  final String? score;
  final bool win;
  final String? color;

  const BggPlayPlayer({
    required this.name,
    required this.username,
    required this.userId,
    required this.score,
    required this.win,
    required this.color,
  });

  factory BggPlayPlayer.fromApiJson(Map<String, dynamic> json) {
    return BggPlayPlayer(
      name: '${json['name'] ?? ''}',
      username: _asNullableString(json['username']),
      userId: _asNullableInt(json['userId']),
      score: _asNullableString(json['score']),
      win: json['win'] == true,
      color: _asNullableString(json['color']),
    );
  }
}

int _asInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

int? _asNullableInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? _asNullableString(Object? value) {
  if (value == null) return null;
  final text = '$value';
  return text.isEmpty ? null : text;
}

DateTime? _asDate(Object? value) {
  if (value == null) return null;
  final parsed = DateTime.tryParse('$value');
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}
