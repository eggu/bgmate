import 'package:xml/xml.dart';

import '../../domain/model/board_game.dart';

class BggXmlParser {
  /// BGG Search API XML 응답 → BoardGame 리스트
  static List<BoardGame> parseSearchResults(String xmlString) {
    if (xmlString.isEmpty) return [];

    final document = XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    return items
        // .where((item) {
        //   // type="alternate"는 제외 — Android에서 경험한 엣지케이스 선제 대응
        //   final type = item.getAttribute('type') ?? '';
        //   return type == 'boardgame';
        // })
        .map((item) => _parseItem(item))
        .whereType<BoardGame>() // null 제거
        .toList();
  }

  static BoardGame? _parseItem(XmlElement item) {
    try {
      final bggId = int.tryParse(item.getAttribute('id') ?? '');
      if (bggId == null) return null;

      // 이름: primary 타입 우선, 없으면 첫 번째
      final nameElements = item.findElements('name');
      final primaryName = nameElements
          .where((e) {
            final type = e.getAttribute('type');
            return type == 'primary' || type == 'alternate';
          })
          .map((e) => e.getAttribute('value') ?? '')
          .firstOrNull;
      final name =
          primaryName ??
          nameElements.map((e) => e.getAttribute('value') ?? '').firstOrNull ??
          '';

      if (name.isEmpty) return null;

      final yearText = item
          .findElements('yearpublished')
          .firstOrNull
          ?.getAttribute('value');

      if (yearText == null || yearText.isEmpty) return null;
      final year = int.tryParse(yearText);
      if (year == null) return null;

      return BoardGame(
        bggId: bggId,
        name: name,
        yearPublished: year,
        thumbnail: '', // Search API에는 썸네일 없음 — Thing API에서 별도 요청
      );
    } catch (_) {
      return null;
    }
  }
}
