import 'dart:io';

import 'package:bgmate_flutter/data/remote/bgg_xml_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BggXmlParser.parseSearchResults', () {
    test('외부 XML 파일을 읽어 검색 결과를 정상적으로 파싱한다', () async {
      final xml = await File(
        'test/fixtures/bgg_search_results_sample.xml',
      ).readAsString();

      final results = BggXmlParser.parseSearchResults(xml);

      expect(results, hasLength(3));

      expect(results[0].bggId, 174430);
      expect(results[0].name, 'Gloomhaven');
      expect(results[0].yearPublished, 2017);
      expect(results[0].thumbnail, isEmpty);

      expect(results[1].bggId, 13);
      expect(results[1].name, 'CATAN');
      expect(results[1].yearPublished, 1995);

      expect(results[2].bggId, 999999);
      expect(results[2].name, 'Nameless Alternate');
      expect(results[2].yearPublished, isNull);
    });

    test('빈 XML 문자열이면 빈 리스트를 반환한다', () {
      expect(BggXmlParser.parseSearchResults(''), isEmpty);
    });
  });
}
