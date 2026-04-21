import 'dart:convert';

import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_response.dart';
import 'package:bgmate_flutter/data/repository/recommend_repository_impl.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommend_repository_test.mocks.dart';

@GenerateMocks([LlmClient, GameRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const ownedPromptAsset = 'assets/prompts/recommend_prompt_owned.txt';
  const allPromptAsset = 'assets/prompts/recommend_prompt_all.txt';

  late RecommendRepositoryImpl repository;
  late MockLlmClient mockLlmClient;

  setUpAll(() {
    provideDummy(const LlmResponse(text: ''));
  });

  setUp(() {
    mockLlmClient = MockLlmClient();
    repository = RecommendRepositoryImpl(
      llmClient: mockLlmClient,
      systemPromptOwned: 'players={playerCount} time={playTime} moods={moods} games={gameList}',
      systemPromptAll: 'players={playerCount} time={playTime} moods={moods} games={gameList}',
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('recommend', () {
    test('첫 호출에서도 비동기 프롬프트 로딩 완료 후 추천을 수행한다', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        final key = const StringCodec().decodeMessage(message);
        if (key == ownedPromptAsset) {
          return ByteData.view(
            Uint8List.fromList(
              utf8.encode(
                '[OWNED] players={playerCount}, playTime={playTime}, moods={moods}, games={gameList}',
              ),
            ).buffer,
          );
        }
        if (key == allPromptAsset) {
          return ByteData.view(
            Uint8List.fromList(
              utf8.encode(
                '[ALL] players={playerCount}, playTime={playTime}, moods={moods}, games={gameList}',
              ),
            ).buffer,
          );
        }
        return null;
      });

      final repo = RecommendRepositoryImpl(llmClient: mockLlmClient);
      when(mockLlmClient.complete(any)).thenAnswer(
        (_) async => const LlmResponse(text: '[]'),
      );

      final result = await repo.recommend(
        condition: const RecommendCondition(
          playerCount: 4,
          playTimeMinutes: PlayTime.medium,
          moods: {Mood.strategy},
        ),
        includeNew: true,
        ownedGames: const [],
      );

      expect(result, isEmpty);
      final captured = verify(mockLlmClient.complete(captureAny)).captured.single
          as LlmRequest;
      final prompt = captured.messages.first.content;
      expect(prompt, contains('[ALL] players=4'));
      expect(prompt, contains('playTime=30~60분'));
      expect(prompt, contains('moods=전략'));
      expect(prompt, contains('games=없음'));
    });

    test('Gemini 503 응답이면 RecommendTemporaryUnavailableException 으로 변환한다',
        () async {
      final requestOptions = RequestOptions(path: '/v1beta/models/gemini');
      final dio503 = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 503,
          data: {'error': 'Service Unavailable'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(mockLlmClient.complete(any)).thenThrow(dio503);

      expect(
        repository.recommend(
          condition: const RecommendCondition(
            playerCount: 4,
            playTimeMinutes: PlayTime.medium,
            moods: {Mood.strategy},
          ),
          includeNew: true,
          ownedGames: const [],
        ),
        throwsA(isA<RecommendTemporaryUnavailableException>()),
      );
    });
  });

  group('buildPrompt - 인원수 기반 필터링', () {
    const condition4p = RecommendCondition(
      playerCount: 4,
      playTimeMinutes: PlayTime.medium,
      moods: {Mood.strategy},
    );

    BoardGame makeGame(int id, {int min = 2, int max = 4}) => BoardGame(
          bggId: id,
          name: 'Game$id',
          yearPublished: 2020,
          minPlayers: min,
          maxPlayers: max,
        );

    test('maxPlayers < playerCount 게임은 프롬프트에 포함되지 않음', () {
      final games = [
        makeGame(1, max: 2), // 2인 max → 4인 불가
        makeGame(2, max: 4), // 4인 max → 포함
        makeGame(3, max: 6), // 6인 max → 포함
      ];
      final prompt = repository.buildPrompt(condition4p, games, false);

      expect(prompt, isNot(contains('Game1')));
      expect(prompt, contains('Game2'));
      expect(prompt, contains('Game3'));
    });

    test('maxPlayers >= playerCount 게임만 포함됨', () {
      final games = List.generate(5, (i) => makeGame(i, max: i + 2));
      // max: 2,3,4,5,6 → playerCount=4이면 max>=4인 id=2,3,4 포함
      final prompt = repository.buildPrompt(condition4p, games, false);

      expect(prompt, isNot(contains('Game0'))); // max=2
      expect(prompt, isNot(contains('Game1'))); // max=3
      expect(prompt, contains('Game2'));         // max=4
      expect(prompt, contains('Game3'));         // max=5
      expect(prompt, contains('Game4'));         // max=6
    });

    test('30개 초과 후보는 최대 30개만 포함됨', () {
      final games = List.generate(50, (i) => makeGame(i, max: 6));
      final prompt = repository.buildPrompt(condition4p, games, false);

      final count = '\n- '.allMatches(prompt).length + (prompt.contains('- ') ? 1 : 0);
      expect(count, lessThanOrEqualTo(30));
    });

    test('maxPlayers==0 (미enrichment) 게임은 후보에서 제외됨', () {
      final games = [
        makeGame(1, min: 0, max: 0), // 미enrichment
        makeGame(2, max: 4),
      ];
      final prompt = repository.buildPrompt(condition4p, games, false);

      expect(prompt, isNot(contains('Game1')));
      expect(prompt, contains('Game2'));
    });

    test('모든 게임이 미enrichment(maxPlayers==0)이면 폴백으로 전체 포함', () {
      final games = [
        makeGame(1, min: 0, max: 0),
        makeGame(2, min: 0, max: 0),
      ];
      final prompt = repository.buildPrompt(condition4p, games, false);

      expect(prompt, contains('Game1'));
      expect(prompt, contains('Game2'));
    });

    test('게임이 없으면 "없음" 표시', () {
      final prompt = repository.buildPrompt(condition4p, [], false);
      expect(prompt, contains('없음'));
    });
  });

  group('parseRecommendResponse', () {
    test('should parse valid JSON array from raw string', () {
      const rawResponse = '''
        Sure! Here are some recommendations:
        [
          {
            "name": "Catan",
            "reason": "Classic gateway game",
            "isOwned": true,
            "bggScore": 7.1,
            "difficulty": "Easy"
          },
          {
            "name": "Pandemic",
            "reason": "Great cooperative experience",
            "isOwned": false,
            "bggScore": 7.5,
            "difficulty": "Medium"
          }
        ]
        Hope you enjoy!
      ''';

      final results = repository.parseRecommendResponse(rawResponse);

      expect(results.length, 2);
      expect(results[0].name, 'Catan');
      expect(results[0].isOwned, true);
      expect(results[0].bggScore, 7.1);
      expect(results[1].name, 'Pandemic');
      expect(results[1].isOwned, false);
      expect(results[1].difficulty, 'Medium');
    });

    test('should return empty list if no JSON array is found', () {
      const rawResponse = 'No games found for your criteria.';
      
      final results = repository.parseRecommendResponse(rawResponse);

      expect(results, isEmpty);
    });

    test('should handle missing optional fields', () {
      const rawResponse = '''
        [
          {
            "name": "Simple Game",
            "reason": "Just because"
          }
        ]
      ''';

      final results = repository.parseRecommendResponse(rawResponse);

      expect(results.length, 1);
      expect(results[0].name, 'Simple Game');
      expect(results[0].isOwned, false); // Default value
      expect(results[0].bggScore, isNull);
      expect(results[0].difficulty, isNull);
    });

    test('should return empty list on invalid JSON', () {
      const rawResponse = '[ { "name": "Broken" '; // Unclosed

      final results = repository.parseRecommendResponse(rawResponse);

      expect(results, isEmpty);
    });

    test('should parse bggScore when it is a string (actual Gemini response format)', () {
      // Gemini가 bggScore를 숫자 대신 문자열로 반환하는 실제 응답 형식
      const rawResponse = '''
[
  {
    "name": "코드네임 (Codenames)",
    "reason": "4명이 두 팀으로 나뉘어 스파이 마스터와 요원으로 플레이하며 단어 힌트로 아군 요원을 찾아내는 팀 기반 게임입니다. 짧은 플레이 시간 안에 재치 있는 단어 연상과 추리 과정을 즐길 수 있어 캐주얼한 분위기에 완벽합니다.",
    "isOwned": false,
    "bggScore": "7.5",
    "difficulty": "가벼움"
  },
  {
    "name": "스시 고! (Sushi Go!)",
    "reason": "귀여운 스시 카드들을 드래프팅하며 세트 메뉴를 모으는 간단한 규칙의 카드 게임입니다. 턴마다 카드를 선택하고 넘기는 빠른 진행으로 4명 모두 쉽고 유쾌하게 즐길 수 있습니다.",
    "isOwned": false,
    "bggScore": "7.0",
    "difficulty": "가벼움"
  },
  {
    "name": "러브레터 (Love Letter)",
    "reason": "단 한 장의 손패로 상대방의 카드를 추리하고 탈락시키는 초간단 추리 카드 게임입니다. 규칙이 매우 직관적이고 게임 회전이 빨라 어떤 모임에서도 즉시 캐주얼한 즐거움을 선사합니다.",
    "isOwned": false,
    "bggScore": "7.2",
    "difficulty": "가벼움"
  }
]''';

      final results = repository.parseRecommendResponse(rawResponse);

      expect(results.length, 3);

      expect(results[0].name, '코드네임 (Codenames)');
      expect(results[0].bggScore, 7.5);
      expect(results[0].difficulty, '가벼움');

      expect(results[1].name, '스시 고! (Sushi Go!)');
      expect(results[1].bggScore, 7.0);

      expect(results[2].name, '러브레터 (Love Letter)');
      expect(results[2].bggScore, 7.2);
    });

    test('should parse 3 results with bggScore and difficulty from realistic API response', () {
      const rawResponse = '''
        조건에 맞는 보드게임 3가지를 추천해드릴게요.

        [
          {
            "name": "스플렌더",
            "reason": "전략적 자원 관리가 핵심인 게임으로, 3~4인 플레이에서 특히 빛납니다. 30~60분 안에 끝나고 규칙이 간결해 처음 하는 분도 금방 익힐 수 있어요.",
            "isOwned": true,
            "bggScore": 7.4,
            "difficulty": "중간"
          },
          {
            "name": "아줄",
            "reason": "타일 배치 전략과 시각적 만족감이 뛰어난 게임입니다. 상대 타일을 가져가는 인터랙션이 경쟁 분위기를 잘 살려줍니다.",
            "isOwned": false,
            "bggScore": 7.8,
            "difficulty": "쉬움"
          },
          {
            "name": "카르카손",
            "reason": "지도를 함께 완성하는 타일 배치 게임으로 협동과 경쟁이 자연스럽게 어우러집니다. 매 판 다른 맵이 완성되어 재플레이성이 높습니다.",
            "isOwned": true,
            "bggScore": 7.5,
            "difficulty": "쉬움"
          }
        ]

        즐거운 게임 시간 되세요!
      ''';

      final results = repository.parseRecommendResponse(rawResponse);

      expect(results.length, 3);

      expect(results[0].name, '스플렌더');
      expect(results[0].isOwned, true);
      expect(results[0].bggScore, 7.4);
      expect(results[0].difficulty, '중간');

      expect(results[1].name, '아줄');
      expect(results[1].isOwned, false);
      expect(results[1].bggScore, 7.8);
      expect(results[1].difficulty, '쉬움');

      expect(results[2].name, '카르카손');
      expect(results[2].isOwned, true);
      expect(results[2].bggScore, 7.5);
      expect(results[2].difficulty, '쉬움');
    });
  });
}
