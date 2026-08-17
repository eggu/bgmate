import 'dart:math' as math;

import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:xml/xml.dart';

class BggPlaysApiService {
  static const _playsPerPage = 100;
  static const _maxPlayPages = 20;
  static const _defaultPageDelay = Duration(seconds: 5);

  final BggApiService _apiService;
  final Duration pageDelay;

  const BggPlaysApiService({
    required BggApiService apiService,
    this.pageDelay = _defaultPageDelay,
  }) : _apiService = apiService;

  bool get isConfigured => _apiService.isConfigured;

  Future<BggPlayDetail> fetchPlays({
    required String username,
    required int bggId,
  }) async {
    if (!isConfigured) {
      throw StateError('BGG_API_TOKEN is missing.');
    }

    final trimmedUsername = username.trim();
    final firstXml = await _apiService.fetchPlaysPage(
      username: trimmedUsername,
      bggId: bggId,
      page: 1,
    );
    final totalPages = math.min(
      (_parseTotalPlays(firstXml) / _playsPerPage).ceil(),
      _maxPlayPages,
    );
    final xmlPages = <String>[firstXml];

    if (totalPages > 1) {
      final remaining = await Future.wait([
        for (var page = 2; page <= totalPages; page++)
          _apiService.fetchPlaysPage(
            username: trimmedUsername,
            bggId: bggId,
            page: page,
          ),
      ]);
      xmlPages.addAll(remaining);
    }

    final plays =
        [for (final xml in xmlPages) ..._parsePlaysXml(xml, bggId: bggId)]
          ..sort(
            (a, b) => b.date.compareTo(a.date) == 0
                ? b.playId.compareTo(a.playId)
                : b.date.compareTo(a.date),
          );

    return BggPlayDetail(
      username: trimmedUsername,
      bggId: bggId,
      plays: plays,
      syncedAt: DateTime.now(),
    );
  }

  Future<BggPlayDetail> fetchUserPlays({required String username}) async {
    if (!isConfigured) {
      throw StateError('BGG_API_TOKEN is missing.');
    }

    final trimmedUsername = username.trim();
    final firstXml = await _apiService.fetchPlaysPage(
      username: trimmedUsername,
      page: 1,
    );
    final totalPages = math.min(
      (_parseTotalPlays(firstXml) / _playsPerPage).ceil(),
      _maxPlayPages,
    );
    final xmlPages = <String>[firstXml];

    for (var page = 2; page <= totalPages; page++) {
      if (pageDelay > Duration.zero) {
        await Future<void>.delayed(pageDelay);
      }
      xmlPages.add(
        await _apiService.fetchPlaysPage(username: trimmedUsername, page: page),
      );
    }

    final plays = [for (final xml in xmlPages) ..._parsePlaysXml(xml)]
      ..sort(
        (a, b) => b.date.compareTo(a.date) == 0
            ? b.playId.compareTo(a.playId)
            : b.date.compareTo(a.date),
      );

    return BggPlayDetail(
      username: trimmedUsername,
      bggId: 0,
      plays: plays,
      syncedAt: DateTime.now(),
    );
  }
}

int _parseTotalPlays(String xml) {
  final document = XmlDocument.parse(xml);
  return _asInt(document.rootElement.getAttribute('total'));
}

List<BggPlaySession> _parsePlaysXml(String xml, {int? bggId}) {
  final document = XmlDocument.parse(xml);
  return [
    for (final play in document.findAllElements('play'))
      if (bggId == null || _playBggId(play) == bggId) _playSession(play),
  ];
}

int _playBggId(XmlElement play) {
  final item = _firstElement(play.findElements('item'));
  return _asInt(item?.getAttribute('objectid'));
}

BggPlaySession _playSession(XmlElement play) {
  return BggPlaySession(
    bggId: _playBggId(play),
    playId: _asInt(play.getAttribute('id')),
    date: _parseDate(play.getAttribute('date')) ?? DateTime(0),
    quantity: _asInt(play.getAttribute('quantity'), fallback: 1),
    lengthMinutes: _asNullableInt(play.getAttribute('length')),
    incomplete: play.getAttribute('incomplete') == '1',
    noWinStats: play.getAttribute('nowinstats') == '1',
    comments: _nullableText(_childText(play, 'comments')),
    players: [
      for (final player in play.findAllElements('player')) _playPlayer(player),
    ].where(_hasPlayerData).toList(),
  );
}

BggPlayPlayer _playPlayer(XmlElement player) {
  return BggPlayPlayer(
    name: player.getAttribute('name') ?? '',
    username: _nullableText(player.getAttribute('username')),
    userId: _asNullableInt(player.getAttribute('userid')),
    score: _nullableText(player.getAttribute('score')),
    win: player.getAttribute('win') == '1',
    color: _nullableText(player.getAttribute('color')),
  );
}

bool _hasPlayerData(BggPlayPlayer player) {
  return player.name.isNotEmpty ||
      (player.username?.isNotEmpty ?? false) ||
      (player.score?.isNotEmpty ?? false);
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

int _asInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

int? _asNullableInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? _nullableText(Object? value) {
  if (value == null) return null;
  final text = '$value'.trim();
  return text.isEmpty ? null : text;
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty || value == '0000-00-00') return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}
