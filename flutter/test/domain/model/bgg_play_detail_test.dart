import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BggPlayDetail.fromApiJson 플레이어 점수와 승리 여부를 변환한다', () {
    final detail = BggPlayDetail.fromApiJson({
      'ok': true,
      'source': 'bgg',
      'username': 'example',
      'bggId': 13,
      'plays': [
        {
          'playId': 9,
          'date': '2026-06-01',
          'quantity': 1,
          'length': 75,
          'incomplete': false,
          'noWinStats': false,
          'comments': 'close game',
          'players': [
            {
              'name': 'Alice',
              'username': 'alice',
              'userId': 1,
              'score': '10',
              'win': true,
              'color': 'red',
            },
            {'name': 'Bob', 'score': '8', 'win': false},
          ],
        },
      ],
      'syncedAt': '2026-07-02T00:00:00.000Z',
    });

    expect(detail.username, 'example');
    expect(detail.bggId, 13);
    expect(detail.plays.single.date, DateTime(2026, 6, 1));
    expect(detail.plays.single.lengthMinutes, 75);
    expect(detail.plays.single.players.first.name, 'Alice');
    expect(detail.plays.single.players.first.score, '10');
    expect(detail.plays.single.players.first.win, isTrue);
  });
}
