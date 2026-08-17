import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_collection_sync_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBggApiService extends BggApiService {
  _FakeBggApiService() : super(token: 'test-token');

  @override
  Future<String> fetchCollection({
    required String username,
    required String subtype,
  }) async {
    if (subtype == 'boardgameexpansion') {
      return '''
<items>
  <item objectid="5" subtype="boardgameexpansion">
    <name>Catan: Seafarers</name>
    <yearpublished>1997</yearpublished>
    <thumbnail>exp-thumb</thumbnail>
    <status own="1"/>
    <numplays>2</numplays>
    <stats><rating value="N/A"><average value="6.9"/></rating></stats>
  </item>
</items>
''';
    }
    return '''
<items>
  <item objectid="13" subtype="boardgame">
    <name>Catan</name>
    <yearpublished>1995</yearpublished>
    <thumbnail>thumb</thumbnail>
    <lastplayed>2026-06-01</lastplayed>
    <status own="1"/>
    <numplays>5</numplays>
    <stats><rating value="N/A"><average value="7.1"/></rating></stats>
  </item>
</items>
''';
  }

  @override
  Future<String> fetchPlaysPage({
    required String username,
    int? bggId,
    int page = 1,
  }) async {
    return '''
<plays total="1" page="1">
  <play id="9" date="2026-06-01">
    <item objectid="13"/>
  </play>
</plays>
''';
  }
}

void main() {
  test('BGG collection XML을 직접 동기화 모델로 변환한다', () async {
    final service = BggCollectionSyncApiService(
      apiService: _FakeBggApiService(),
    );

    final sync = await service.fetchCollection('  kurt ');

    expect(sync.username, 'kurt');
    expect(sync.games, hasLength(2));

    final catan = sync.games.singleWhere((game) => game.game.bggId == 13);
    expect(catan.game.name, 'Catan');
    expect(catan.game.yearPublished, 1995);
    expect(catan.game.thumbnail, 'thumb');
    expect(catan.playCount, 5);
    expect(catan.lastPlayedAt, DateTime(2026, 6, 1));
    expect(catan.rating, 7.1);
    expect(catan.isExpansion, isFalse);

    final expansion = sync.games.singleWhere((game) => game.game.bggId == 5);
    expect(expansion.isExpansion, isTrue);
  });
}
