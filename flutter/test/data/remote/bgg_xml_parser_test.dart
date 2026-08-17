import 'dart:io';

import 'package:bgmate_flutter/data/remote/bgg_xml_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BggXmlParser.parseThingResults', () {
    test('Thing XML을 파싱해 상세 정보를 포함한 BoardGame 리스트를 반환한다', () async {
      final xml = await File(
        'test/fixtures/bgg_thing_results_sample.xml',
      ).readAsString();

      final results = BggXmlParser.parseThingResults(xml);

      expect(results, hasLength(3));

      expect(results[0].bggId, 174430);
      expect(results[0].name, 'Gloomhaven');
      expect(results[0].yearPublished, 2017);
      expect(
        results[0].thumbnail,
        'https://cf.geekdo-images.com/gloomhaven.jpg',
      );
      expect(results[0].minPlayers, 1);
      expect(results[0].maxPlayers, 4);
      expect(results[0].playingTime, 120);

      expect(results[1].bggId, 13);
      expect(results[1].minPlayers, 3);
      expect(results[1].maxPlayers, 4);
      expect(results[1].playingTime, 90);

      // 썸네일 없는 항목도 정상 파싱
      expect(results[2].bggId, 9999);
      expect(results[2].thumbnail, isEmpty);
    });

    test('빈 XML 문자열이면 빈 리스트를 반환한다', () {
      expect(BggXmlParser.parseThingResults(''), isEmpty);
    });

    test('id가 없는 item은 파싱 결과에서 제외된다', () {
      const xml = '''
    <?xml version="1.0" encoding="utf-8"?>
    <items>
      <item type="boardgame">
        <name type="primary" value="No ID Game"/>
      </item>
    </items>
  ''';
      expect(BggXmlParser.parseThingResults(xml), isEmpty);
    });
  });

  group('BggXmlParser.parseSearchResults', () {
    test('외부 XML 파일을 읽어 검색 결과를 정상적으로 파싱한다', () async {
      final xml = await File(
        'test/fixtures/bgg_search_results_sample.xml',
      ).readAsString();

      final results = BggXmlParser.parseSearchResults(xml);

      // yearpublished 없는 항목(id=999999)은 필터링 → 2건
      expect(results, hasLength(2));

      expect(results[0].bggId, 174430);
      expect(results[0].name, 'Gloomhaven');
      expect(results[0].yearPublished, 2017);
      expect(results[0].thumbnail, isEmpty);

      expect(results[1].bggId, 13);
      expect(results[1].name, 'CATAN');
      expect(results[1].yearPublished, 1995);
    });

    test('빈 XML 문자열이면 빈 리스트를 반환한다', () {
      expect(BggXmlParser.parseSearchResults(''), isEmpty);
    });

    test('id가 없는 item은 파싱 결과에서 제외된다', () {
      const xml = '''
    <?xml version="1.0" encoding="utf-8"?>
    <items total="1">
      <item type="boardgame">
        <name type="primary" value="No ID Game"/>
      </item>
    </items>
  ''';
      expect(BggXmlParser.parseSearchResults(xml), isEmpty);
    });

    test('alternate 이름이 먼저 와도 primary 이름을 사용한다', () {
      const xml = '''
    <?xml version="1.0" encoding="utf-8"?>
    <items total="1">
      <item type="boardgame" id="123">
        <name type="alternate" value="비뉴스 딜럭스 에디션"/>
        <name type="primary" value="Venus: Deluxe Edition"/>
        <yearpublished value="2025"/>
      </item>
    </items>
  ''';

      final results = BggXmlParser.parseSearchResults(xml);

      expect(results.single.name, 'Venus: Deluxe Edition');
    });
  });
}
