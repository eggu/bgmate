import 'dart:convert';

import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/domain/repository/recommend_repository.dart';
import 'package:flutter/services.dart';

class RecommendRepositoryImpl implements RecommendRepository {
  final LlmClient llmClient;
  String? _systemPromptOwned;
  String? _systemPromptAll;

  RecommendRepositoryImpl({
    required this.llmClient,
    String? systemPromptOwned,
    String? systemPromptAll,
  })  : _systemPromptOwned = systemPromptOwned,
        _systemPromptAll = systemPromptAll {
    if (_systemPromptOwned == null || _systemPromptAll == null) {
      _loadPrompt();
    }
  }

  Future<void> _loadPrompt() async {
    _systemPromptOwned = await rootBundle.loadString(
      'assets/prompts/recommend_prompt_owned.txt',
    );
    _systemPromptAll = await rootBundle.loadString(
      'assets/prompts/recommend_prompt_all.txt',
    );
  }

  @override
  Future<List<RecommendResult>> recommend({
    required RecommendCondition condition,
    required bool includeNew,
    required List<BoardGame> ownedGames,
  }) async {
    final prompt = buildPrompt(condition, ownedGames, includeNew);
    final request = LlmRequest(
      messages: [LlmMessage(role: 'user', content: prompt)],
      maxTokens: 8192,
    );
    final response = await llmClient.complete(request);
    return parseRecommendResponse(response.text);
  }

  String buildPrompt(
    RecommendCondition condition,
    List<BoardGame> ownedGames,
    bool includeNew,
  ) {
    final moodText = condition.moods.map((e) => e.label).join(', ');
    final gameListText = ownedGames.isEmpty
        ? '없음'
        : ownedGames.take(30).map((e) => '- ${e.name}').join('\n');
    final template = includeNew ? _systemPromptAll : _systemPromptOwned;
    if (template == null) throw ArgumentError('Prompt is null');
    return template
        .replaceAll('{playerCount}', condition.playerCount.toString())
        .replaceAll('{playTime}', condition.playTimeMinutes.label)
        .replaceAll('{moods}', moodText)
        .replaceAll('{gameList}', gameListText);
  }

  static double? _parseScore(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  List<RecommendResult> parseRecommendResponse(String raw) {
    try {
      final start = raw.indexOf('[');
      final end = raw.lastIndexOf(']') + 1;
      if (start == -1 || end == 0) return [];

      final jsonString = raw.substring(start, end);
      final List<dynamic> list = jsonDecode(jsonString);

      return list.map((item) {
        final map = item as Map<String, dynamic>;
        return RecommendResult(
          name: map['name'] as String,
          reason: map['reason'] as String,
          isOwned: map['isOwned'] as bool? ?? false,
          bggScore: _parseScore(map['bggScore']),
          difficulty: map['difficulty'] as String?,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
