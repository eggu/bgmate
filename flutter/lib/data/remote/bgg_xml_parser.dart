import 'package:xml/xml.dart';

import '../../domain/model/board_game.dart';
import '../../domain/model/collection_status.dart';
import '../../domain/model/game_source.dart';

class BggXmlParser {
  /// BGG Thing API XML 응답 → BoardGame 리스트 (상세 정보 포함)
  static List<BoardGame> parseThingResults(String xmlString) {
    if (xmlString.isEmpty) return [];

    final document = XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    return items
        .map((item) => _parseThingItem(item))
        .whereType<BoardGame>()
        .toList();
  }

  static BoardGame? _parseThingItem(XmlElement item) {
    try {
      final bggId = int.tryParse(item.getAttribute('id') ?? '');
      if (bggId == null) return null;

      final nameElements = item.findElements('name');
      final primaryName = nameElements
          .where((e) => e.getAttribute('type') == 'primary')
          .map((e) => e.getAttribute('value') ?? '')
          .firstOrNull;
      final name =
          primaryName ??
          nameElements.map((e) => e.getAttribute('value') ?? '').firstOrNull ??
          '';
      if (name.isEmpty) return null;

      final year =
          int.tryParse(
            item
                    .findElements('yearpublished')
                    .firstOrNull
                    ?.getAttribute('value') ??
                '',
          ) ??
          0;

      final thumbnail =
          item.findElements('thumbnail').firstOrNull?.innerText.trim() ?? '';

      final minPlayers =
          int.tryParse(
            item
                    .findElements('minplayers')
                    .firstOrNull
                    ?.getAttribute('value') ??
                '',
          ) ??
          0;

      final maxPlayers =
          int.tryParse(
            item
                    .findElements('maxplayers')
                    .firstOrNull
                    ?.getAttribute('value') ??
                '',
          ) ??
          0;

      final playingTime =
          int.tryParse(
            item
                    .findElements('playingtime')
                    .firstOrNull
                    ?.getAttribute('value') ??
                '',
          ) ??
          0;

      final description =
          item.findElements('description').firstOrNull?.innerText.trim() ?? '';

      return BoardGame(
        bggId: bggId,
        name: name,
        yearPublished: year,
        thumbnail: thumbnail,
        minPlayers: minPlayers,
        maxPlayers: maxPlayers,
        playingTime: playingTime,
        description: description,
      );
    } catch (_) {
      return null;
    }
  }

  /// BGG Collection API XML 응답 → BoardGame 리스트
  static List<BoardGame> parseCollectionResults(String xmlString) {
    if (xmlString.isEmpty) return [];

    final document = XmlDocument.parse(xmlString);
    final items = document.findAllElements('item').where(
      (e) => e.getAttribute('subtype') == 'boardgame',
    );

    return items
        .map((item) => _parseCollectionItem(item))
        .whereType<BoardGame>()
        .toList();
  }

  static BoardGame? _parseCollectionItem(XmlElement item) {
    try {
      final bggId = int.tryParse(item.getAttribute('objectid') ?? '');
      if (bggId == null) return null;

      final name =
          item.findElements('name').firstOrNull?.innerText.trim() ?? '';
      if (name.isEmpty) return null;

      final year =
          int.tryParse(
            item.findElements('yearpublished').firstOrNull?.innerText.trim() ??
                '',
          ) ??
          0;

      final thumbnail =
          item.findElements('thumbnail').firstOrNull?.innerText.trim() ?? '';

      final statsEl = item.findElements('stats').firstOrNull;
      final minPlayers =
          int.tryParse(statsEl?.getAttribute('minplayers') ?? '') ?? 0;
      final maxPlayers =
          int.tryParse(statsEl?.getAttribute('maxplayers') ?? '') ?? 0;
      final playingTime =
          int.tryParse(statsEl?.getAttribute('playingtime') ?? '') ?? 0;

      final statusEl = item.findElements('status').firstOrNull;
      final statuses = _parseStatuses(statusEl);
      if (statuses.isEmpty) return null;

      return BoardGame(
        bggId: bggId,
        name: name,
        yearPublished: year,
        thumbnail: thumbnail.startsWith('//') ? 'https:$thumbnail' : thumbnail,
        minPlayers: minPlayers,
        maxPlayers: maxPlayers,
        playingTime: playingTime,
        statuses: statuses,
        source: GameSource.bggSync,
      );
    } catch (_) {
      return null;
    }
  }

  static Set<CollectionStatus> _parseStatuses(XmlElement? statusEl) {
    if (statusEl == null) return {};
    final statuses = <CollectionStatus>{};
    if (statusEl.getAttribute('own') == '1') statuses.add(CollectionStatus.owned);
    if (statusEl.getAttribute('prevowned') == '1') statuses.add(CollectionStatus.prevOwned);
    if (statusEl.getAttribute('fortrade') == '1') statuses.add(CollectionStatus.forTrade);
    if (statusEl.getAttribute('wanttoplay') == '1') statuses.add(CollectionStatus.wantToPlay);
    if (statusEl.getAttribute('wishlist') == '1') statuses.add(CollectionStatus.wishlist);
    return statuses;
  }

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
