import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_stats_provider.dart';
import 'package:bgmate_flutter/presentation/session_history/session_history_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('전적 상세 플레이어는 저장된 순위 기준으로 표시된다', () {
    const players = [
      PlayerScore(id: 1, sessionId: 1, name: '2등', score: 19, rank: 2),
      PlayerScore(id: 2, sessionId: 1, name: '1등', score: 21, rank: 1),
      PlayerScore(id: 3, sessionId: 1, name: '3등', score: 10, rank: 3),
    ];

    final sorted = sortSessionDetailPlayers(players);

    expect(sorted.map((player) => player.name), ['1등', '2등', '3등']);
  });

  test('전적 상세 날짜는 Android 상세 화면과 같은 분 단위 형식으로 표시된다', () {
    final formatted = formatSessionDetailDate(DateTime(2026, 7, 2, 9, 5));

    expect(formatted, '2026년 7월 2일 09:05');
  });

  test('BGG 전적 상세는 전적 관련 정보만 표시한다', () {
    final rows = buildBggPlayStatsDetailRows(
      BggPlayStatsEntry(
        game: BoardGame(
          bggId: 13,
          name: 'Catan',
          yearPublished: 1995,
          isInCollection: true,
        ),
        playCount: 5,
        lastPlayedAt: DateTime(2026, 6, 1),
        rating: 7.2,
        isExpansion: false,
      ),
    );

    expect(rows, [
      (label: '플레이 횟수', value: '5회'),
      (label: '마지막 플레이', value: '2026.06.01'),
    ]);
  });

  test('BGG 전적 상세는 마지막 플레이가 없어도 전적 행을 유지한다', () {
    final rows = buildBggPlayStatsDetailRows(
      const BggPlayStatsEntry(
        game: BoardGame(bggId: 1, name: 'No Score', yearPublished: 0),
        playCount: 1,
        lastPlayedAt: null,
        rating: null,
        isExpansion: true,
      ),
    );

    expect(rows, [
      (label: '플레이 횟수', value: '1회'),
      (label: '마지막 플레이', value: '기록 없음'),
    ]);
  });

  test('BGG 플레이어는 승리 여부와 점수 기준으로 표시한다', () {
    const players = [
      BggPlayPlayer(
        name: 'Low',
        username: null,
        userId: null,
        score: '7',
        win: false,
        color: null,
      ),
      BggPlayPlayer(
        name: 'Winner',
        username: null,
        userId: null,
        score: '5',
        win: true,
        color: null,
      ),
      BggPlayPlayer(
        name: 'High',
        username: null,
        userId: null,
        score: '9',
        win: false,
        color: null,
      ),
    ];

    final sorted = sortBggPlayPlayers(players);

    expect(sorted.map((player) => player.name), ['Winner', 'High', 'Low']);
  });
}
