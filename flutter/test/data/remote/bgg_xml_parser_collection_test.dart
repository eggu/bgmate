import 'dart:io';

import 'package:bgmate_flutter/data/remote/bgg_xml_parser.dart';
import 'package:bgmate_flutter/domain/model/collection_status.dart';
import 'package:bgmate_flutter/domain/model/game_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String readFixture(String name) =>
      File('test/fixtures/$name').readAsStringSync();

  group('BggXmlParser.parseCollectionResults', () {
    test('빈 컬렉션 XML → 빈 리스트 반환', () {
      final xml = readFixture('bgg_collection_empty.xml');
      final result = BggXmlParser.parseCollectionResults(xml);
      expect(result, isEmpty);
    });

    test('단일 상태 (own=1만) → {owned}', () {
      final xml = readFixture('bgg_collection_single_status.xml');
      final games = BggXmlParser.parseCollectionResults(xml);

      expect(games, hasLength(1));
      expect(games.first.statuses, equals({CollectionStatus.owned}));
    });

    test('복수 상태 (own=1, wanttoplay=1) → {owned, wantToPlay}', () {
      final xml = readFixture('bgg_collection_multi_status.xml');
      final games = BggXmlParser.parseCollectionResults(xml);

      expect(games, hasLength(1));
      expect(
        games.first.statuses,
        equals({CollectionStatus.owned, CollectionStatus.wantToPlay}),
      );
    });

    test('파싱된 게임의 source는 bggSync', () {
      final xml = readFixture('bgg_collection_single_status.xml');
      final games = BggXmlParser.parseCollectionResults(xml);

      expect(games.first.source, equals(GameSource.bggSync));
    });

    test('thumbnail URL에 https: 프리픽스 추가', () {
      final xml = readFixture('bgg_collection_single_status.xml');
      final games = BggXmlParser.parseCollectionResults(xml);

      expect(games.first.thumbnail, startsWith('https://'));
    });

    test('bggId, name, yearPublished 정확히 파싱', () {
      final xml = readFixture('bgg_collection_single_status.xml');
      final game = BggXmlParser.parseCollectionResults(xml).first;

      expect(game.bggId, equals(174430));
      expect(game.name, equals('Gloomhaven'));
      expect(game.yearPublished, equals(2017));
    });

    test('stats에서 minPlayers, maxPlayers 파싱', () {
      final xml = readFixture('bgg_collection_single_status.xml');
      final game = BggXmlParser.parseCollectionResults(xml).first;

      expect(game.minPlayers, equals(1));
      expect(game.maxPlayers, equals(4));
    });

    test('빈 XML 문자열 → 빈 리스트', () {
      final result = BggXmlParser.parseCollectionResults('');
      expect(result, isEmpty);
    });
  });
}
