import 'package:bgmate_flutter/data/local/session_dao.dart';
import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';

List<BggSessionImport> buildBggSessionImports(BggPlayDetail detail) {
  final imports = <BggSessionImport>[];

  for (final play in detail.plays) {
    final scores = <({String name, int score, bool win})>[];
    for (final player in play.players) {
      final score = _scoreAsInt(player.score);
      if (score == null) continue;
      final name = _playerName(player);
      if (name.isEmpty) continue;
      scores.add((name: name, score: score, win: player.win));
    }

    scores.sort((a, b) {
      if (a.win != b.win) return a.win ? -1 : 1;
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      return a.name.compareTo(b.name);
    });

    var nextRank = scores.any((score) => score.win) ? 2 : 1;
    imports.add((
      bggId: play.bggId ?? detail.bggId,
      bggPlayId: play.playId,
      playedAt: play.date,
      scores: [
        for (final score in scores)
          (
            name: score.name,
            score: score.score,
            rank: score.win ? 1 : nextRank++,
          ),
      ],
    ));
  }

  return imports;
}

String _playerName(BggPlayPlayer player) {
  final name = player.name.trim();
  if (name.isNotEmpty) return name;
  return player.username?.trim() ?? '';
}

int? _scoreAsInt(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  return int.tryParse(text);
}
