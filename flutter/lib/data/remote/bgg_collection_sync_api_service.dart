import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/domain/model/bgg_collection_sync.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:xml/xml.dart';

class BggCollectionSyncApiService {
  static const _baseSubtype = 'boardgame';
  static const _expansionSubtype = 'boardgameexpansion';

  final BggApiService _apiService;

  const BggCollectionSyncApiService({required BggApiService apiService})
    : _apiService = apiService;

  bool get isConfigured => _apiService.isConfigured;

  Future<BggCollectionSync> fetchCollection(String username) async {
    if (!isConfigured) {
      throw StateError('BGG_API_TOKEN is missing.');
    }

    final trimmedUsername = username.trim();
    final results = await Future.wait([
      _apiService.fetchCollection(
        username: trimmedUsername,
        subtype: _baseSubtype,
      ),
      _apiService.fetchCollection(
        username: trimmedUsername,
        subtype: _expansionSubtype,
      ),
    ]);

    final gamesById = <int, BggCollectionSyncGame>{};
    for (final game in _parseCollectionXml(results[0], isExpansion: false)) {
      gamesById[game.game.bggId] = game;
    }
    for (final game in _parseCollectionXml(results[1], isExpansion: true)) {
      gamesById[game.game.bggId] = game;
    }

    return BggCollectionSync(
      username: trimmedUsername,
      syncedAt: DateTime.now(),
      games: [
        for (final game in gamesById.values)
          BggCollectionSyncGame(
            game: game.game,
            playCount: game.playCount,
            lastPlayedAt: game.lastPlayedAt,
            rating: game.rating,
            isExpansion: game.isExpansion,
          ),
      ],
    );
  }
}

List<BggCollectionSyncGame> _parseCollectionXml(
  String xml, {
  required bool isExpansion,
}) {
  final document = XmlDocument.parse(xml);
  return [
    for (final item in document.findAllElements('item'))
      if (_owned(item)) _collectionGameFromItem(item, isExpansion: isExpansion),
  ].where((game) => game.game.bggId > 0).toList();
}

BggCollectionSyncGame _collectionGameFromItem(
  XmlElement item, {
  required bool isExpansion,
}) {
  final bggId = _asInt(item.getAttribute('objectid'));
  final name = _childText(item, 'name');
  return BggCollectionSyncGame(
    game: BoardGame(
      bggId: bggId,
      name: name,
      yearPublished: _asInt(_childText(item, 'yearpublished')),
      thumbnail: _childText(item, 'thumbnail'),
      isInCollection: true,
    ),
    playCount: _asInt(_childText(item, 'numplays')),
    lastPlayedAt: _parseDate(_childText(item, 'lastplayed')),
    rating: _rating(item),
    isExpansion:
        isExpansion || item.getAttribute('subtype') == 'boardgameexpansion',
  );
}

bool _owned(XmlElement item) {
  final status = _firstElement(item.findElements('status'));
  return status?.getAttribute('own') == '1';
}

double? _rating(XmlElement item) {
  final stats = _firstElement(item.findElements('stats'));
  final rating = stats == null
      ? null
      : _firstElement(stats.findElements('rating'));
  final average = rating == null
      ? null
      : _firstElement(rating.findElements('average'));
  return _asDouble(average?.getAttribute('value'));
}

String _childText(XmlElement element, String name) {
  return _firstElement(element.findElements(name))?.innerText.trim() ?? '';
}

XmlElement? _firstElement(Iterable<XmlElement> elements) {
  for (final element in elements) {
    return element;
  }
  return null;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty || value == '0000-00-00') return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}
