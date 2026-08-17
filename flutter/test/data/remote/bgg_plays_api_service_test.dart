import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_plays_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBggApiService extends BggApiService {
  _FakeBggApiService() : super(token: 'test-token');

  final calls = <({String username, int? bggId, int page})>[];

  @override
  Future<String> fetchPlaysPage({
    required String username,
    int? bggId,
    int page = 1,
  }) async {
    calls.add((username: username, bggId: bggId, page: page));
    if (page == 2) {
      return '''
<plays total="101" page="2">
  <play id="10" date="2026-06-02" quantity="1" length="30" incomplete="0" nowinstats="0">
    <item name="Splendor" objecttype="thing" objectid="148228"/>
  </play>
</plays>
''';
    }
    return '''
<plays total="101" page="1">
  <play id="9" date="2026-06-01" quantity="1" length="75" incomplete="0" nowinstats="0">
    <item name="Catan" objecttype="thing" objectid="13"/>
    <comments>close game</comments>
    <players>
      <player username="alice" userid="1" name="Alice" color="red" score="10" win="1"/>
      <player username="bob" userid="2" name="Bob" color="blue" score="8" win="0"/>
    </players>
  </play>
</plays>
''';
  }
}

void main() {
  test('BGG plays XML을 플레이어 점수와 승패 포함 상세 모델로 변환한다', () async {
    final api = _FakeBggApiService();
    final service = BggPlaysApiService(apiService: api);

    final detail = await service.fetchPlays(username: '  kurt ', bggId: 13);

    expect(detail.username, 'kurt');
    expect(detail.bggId, 13);
    expect(detail.plays, hasLength(1));

    final play = detail.plays.single;
    expect(play.playId, 9);
    expect(play.date, DateTime(2026, 6, 1));
    expect(play.lengthMinutes, 75);
    expect(play.comments, 'close game');
    expect(play.players.map((player) => player.score), ['10', '8']);
    expect(play.players.map((player) => player.win), [true, false]);
    expect(api.calls.map((call) => call.bggId).toSet(), {13});
  });

  test('사용자 전체 plays를 페이지 단위로 받아 각 play의 bggId를 유지한다', () async {
    final api = _FakeBggApiService();
    final service = BggPlaysApiService(
      apiService: api,
      pageDelay: Duration.zero,
    );

    final detail = await service.fetchUserPlays(username: '  kurt ');

    expect(api.calls, [
      (username: 'kurt', bggId: null, page: 1),
      (username: 'kurt', bggId: null, page: 2),
    ]);
    expect(detail.bggId, 0);
    expect(detail.plays.map((play) => play.bggId), [148228, 13]);
  });
}
