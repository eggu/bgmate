import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_play_import.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BGG 플레이 상세 응답을 로컬 전적 import 데이터로 변환한다', () {
    final imports = buildBggSessionImports(
      BggPlayDetail(
        username: 'kurt',
        bggId: 13,
        syncedAt: DateTime(2026, 7, 2),
        plays: [
          BggPlaySession(
            playId: 9001,
            date: DateTime(2026, 6, 1),
            quantity: 1,
            lengthMinutes: 75,
            incomplete: false,
            noWinStats: false,
            comments: null,
            players: const [
              BggPlayPlayer(
                name: 'Bob',
                username: null,
                userId: null,
                score: '8',
                win: false,
                color: null,
              ),
              BggPlayPlayer(
                name: 'Alice',
                username: null,
                userId: null,
                score: '10',
                win: true,
                color: null,
              ),
              BggPlayPlayer(
                name: 'No score',
                username: null,
                userId: null,
                score: null,
                win: false,
                color: null,
              ),
            ],
          ),
        ],
      ),
    );

    expect(imports, hasLength(1));
    expect(imports.single.bggPlayId, 9001);
    expect(imports.single.scores, [
      (name: 'Alice', score: 10, rank: 1),
      (name: 'Bob', score: 8, rank: 2),
    ]);
  });

  test('BGG 플레이어 점수가 없어도 전적 import는 유지한다', () {
    final imports = buildBggSessionImports(
      BggPlayDetail(
        username: 'kurt',
        bggId: 13,
        syncedAt: DateTime(2026, 7, 2),
        plays: [
          BggPlaySession(
            playId: 9002,
            date: DateTime(2026, 6, 2),
            quantity: 1,
            lengthMinutes: null,
            incomplete: false,
            noWinStats: false,
            comments: null,
            players: const [],
          ),
        ],
      ),
    );

    expect(imports, hasLength(1));
    expect(imports.single.bggPlayId, 9002);
    expect(imports.single.scores, isEmpty);
  });
}
