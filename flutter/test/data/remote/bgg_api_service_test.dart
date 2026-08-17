import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('collectionUri는 BoardGameGeek XML API2를 직접 가리킨다', () {
    final uri = BggApiService.collectionUri(
      username: '  kurt ',
      subtype: 'boardgame',
    );

    expect(
      '${uri.scheme}://${uri.host}${uri.path}',
      'https://boardgamegeek.com/xmlapi2/collection',
    );
    expect(uri.queryParameters, {
      'username': 'kurt',
      'own': '1',
      'stats': '1',
      'subtype': 'boardgame',
    });
  });

  test('playsUri는 BoardGameGeek XML API2를 직접 가리킨다', () {
    final uri = BggApiService.playsUri(username: '  kurt ', bggId: 13, page: 2);

    expect(
      '${uri.scheme}://${uri.host}${uri.path}',
      'https://boardgamegeek.com/xmlapi2/plays',
    );
    expect(uri.queryParameters, {'username': 'kurt', 'id': '13', 'page': '2'});
  });
}
