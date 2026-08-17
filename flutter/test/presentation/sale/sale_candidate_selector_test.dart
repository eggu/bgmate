import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/game_play_stats.dart';
import 'package:bgmate_flutter/domain/model/session_history.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('selectSaleCandidates', () {
    test('미플레이 게임과 오래 플레이하지 않은 게임만 추천한다', () {
      final now = DateTime(2026, 7, 2);
      final games = [
        _game(1, 'Never Played'),
        _game(2, 'Old Played'),
        _game(3, 'Recent Played'),
      ];
      final stats = {
        2: GamePlayStats(
          bggId: 2,
          playCount: 3,
          lastPlayedAt: DateTime(2022, 1, 1),
          rating: 6.5,
        ),
        3: GamePlayStats(
          bggId: 3,
          playCount: 1,
          lastPlayedAt: DateTime(2026, 5, 1),
          rating: null,
        ),
      };

      final candidates = selectSaleCandidates(
        games: games,
        statsByBggId: stats,
        now: now,
        filters: const SaleFilters(minPlays: 0),
      );

      expect(candidates.map((c) => c.game.bggId), [1, 2]);
      expect(candidates.first.playCount, 0);
      expect(candidates.first.lastPlayedAt, isNull);
      expect(candidates.first.score, greaterThan(candidates.last.score));
    });

    test('maxCandidates만큼 점수 높은 후보만 반환한다', () {
      final candidates = selectSaleCandidates(
        games: [_game(1, 'A'), _game(2, 'B')],
        statsByBggId: const {},
        now: DateTime(2026, 7, 2),
        filters: const SaleFilters(minPlays: 0, maxCandidates: 1),
      );

      expect(candidates, hasLength(1));
    });

    test('bgcut 필터처럼 게임 종류와 최소 플레이 횟수를 적용한다', () {
      final now = DateTime(2026, 7, 2);
      final games = [_game(1, 'Base'), _game(2, 'Expansion'), _game(3, 'Low')];
      final stats = {
        1: GamePlayStats(
          bggId: 1,
          playCount: 2,
          lastPlayedAt: DateTime(2020, 1, 1),
          rating: null,
          isExpansion: false,
        ),
        2: GamePlayStats(
          bggId: 2,
          playCount: 2,
          lastPlayedAt: DateTime(2020, 1, 1),
          rating: null,
          isExpansion: true,
        ),
        3: GamePlayStats(
          bggId: 3,
          playCount: 0,
          lastPlayedAt: null,
          rating: null,
          isExpansion: false,
        ),
      };

      final baseOnly = selectSaleCandidates(
        games: games,
        statsByBggId: stats,
        now: now,
        filters: const SaleFilters(
          gameType: SaleGameTypeFilter.base,
          minPlays: 1,
        ),
      );
      final expansionsOnly = selectSaleCandidates(
        games: games,
        statsByBggId: stats,
        now: now,
        filters: const SaleFilters(
          gameType: SaleGameTypeFilter.expansion,
          minPlays: 1,
        ),
      );

      expect(baseOnly.map((c) => c.game.bggId), [1]);
      expect(expansionsOnly.map((c) => c.game.bggId), [2]);
    });
  });

  group('mergeGamePlayStats', () {
    test('BGG 전적과 로컬 전적은 합산하지 않고 더 큰 playCount와 최신 날짜를 사용한다', () {
      final game = _game(1, 'Catan');

      final stats = mergeGamePlayStats(
        syncedStats: [
          GamePlayStats(
            bggId: 1,
            playCount: 5,
            lastPlayedAt: DateTime(2024, 1, 1),
            rating: 7.2,
          ),
        ],
        localSessions: [
          SessionHistory(
            id: 1,
            game: game,
            scores: const [],
            playedAt: DateTime(2026, 7, 1),
          ),
          SessionHistory(
            id: 2,
            game: game,
            scores: const [],
            playedAt: DateTime(2026, 6, 1),
          ),
        ],
      );

      expect(stats[1]!.playCount, 5);
      expect(stats[1]!.lastPlayedAt, DateTime(2026, 7, 1));
      expect(stats[1]!.rating, 7.2);
    });
  });
}

BoardGame _game(int bggId, String name) =>
    BoardGame(bggId: bggId, name: name, yearPublished: 2020);
