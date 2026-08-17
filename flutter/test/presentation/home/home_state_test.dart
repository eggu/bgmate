import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/home/home_state.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:flutter_test/flutter_test.dart';

BoardGame _game(int id) => BoardGame(
  bggId: id,
  name: 'Game $id',
  yearPublished: 2000 + id,
  minPlayers: 2,
  maxPlayers: 4,
  playingTime: 45,
);

void main() {
  test('HomeState.from orders recent games by latest played session', () {
    final games = [_game(1), _game(2), _game(3), _game(4)];
    final saleCandidates = [
      for (final game in games)
        SaleCandidate(
          game: game,
          playCount: 1,
          lastPlayedAt: DateTime(2020, 1, 1),
          rating: null,
          score: 10,
          yearsUnplayed: 4,
        ),
    ];
    final sessions = [
      SessionHistory(
        id: 1,
        game: games[1],
        scores: const [PlayerScore(name: 'Kurt', score: 10, rank: 1)],
        playedAt: DateTime(2026, 7, 1),
      ),
      SessionHistory(
        id: 2,
        game: games[3],
        scores: const [PlayerScore(name: 'Kurt', score: 10, rank: 1)],
        playedAt: DateTime(2026, 7, 4),
      ),
      SessionHistory(
        id: 3,
        game: games[1],
        scores: const [PlayerScore(name: 'Kurt', score: 10, rank: 1)],
        playedAt: DateTime(2026, 7, 5),
      ),
    ];

    final state = HomeState.from(
      games: games,
      saleCandidates: saleCandidates,
      sessions: sessions,
    );

    expect(state.hasCollection, isTrue);
    expect(state.recentGames, [games[1], games[3], games[0]]);
    expect(state.salePreview, saleCandidates.take(3));
  });

  test('HomeState.from reports empty collection', () {
    final state = HomeState.from(
      games: const [],
      saleCandidates: const [],
      sessions: const [],
    );

    expect(state.hasCollection, isFalse);
    expect(state.recentGames, isEmpty);
    expect(state.salePreview, isEmpty);
  });
}
