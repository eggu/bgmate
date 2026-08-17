import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/game_play_stats.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_stats_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BGG 동기화 전적은 플레이 횟수가 있는 게임만 최신순으로 표시한다', () {
    final entries = buildBggPlayStatsEntries(
      games: const [
        BoardGame(bggId: 1, name: 'Old', yearPublished: 2020),
        BoardGame(bggId: 2, name: 'Zero', yearPublished: 2020),
        BoardGame(bggId: 3, name: 'Recent', yearPublished: 2020),
      ],
      stats: [
        GamePlayStats(
          bggId: 1,
          playCount: 3,
          lastPlayedAt: DateTime(2025, 1, 1),
          rating: 6.5,
        ),
        GamePlayStats(bggId: 2, playCount: 0, lastPlayedAt: null, rating: null),
        GamePlayStats(
          bggId: 3,
          playCount: 5,
          lastPlayedAt: DateTime(2026, 1, 1),
          rating: 8,
        ),
      ],
    );

    expect(entries.map((e) => e.game.bggId), [3, 1]);
    expect(entries.first.playCount, 5);
    expect(entries.first.rating, 8);
  });

  test('BGG 동기화 전적 상세 이동은 전적 상세로 보낸다', () {
    const entry = BggPlayStatsEntry(
      game: BoardGame(bggId: 13, name: 'Catan', yearPublished: 1995),
      playCount: 5,
      lastPlayedAt: null,
      rating: null,
    );

    expect(bggPlayStatsDetailLocation(entry), '/session/bgg/13');
  });
}
