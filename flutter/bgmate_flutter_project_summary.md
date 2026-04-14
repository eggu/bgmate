# BGMate Flutter — Claude Code 가이드

보드게임 동반자 앱 (컬렉션 관리, 점수 기록, AI 규칙 판정).

---

## 기술 스택

| 영역 | 라이브러리 |
|------|-----------|
| 상태 관리 | flutter_riverpod ^3.3.1 + riverpod_annotation |
| 라우팅 | go_router ^17.2.0 |
| 로컬 DB | drift 2.31.0 (SQLite) |
| 불변 모델 | freezed_annotation ^3.1.0 |
| 네트워크 | dio ^5.9.2 |
| AI | Google Generative AI (Gemini 2.5 Flash, SSE 스트리밍) |
| 이미지 | cached_network_image ^3.4.1 |
| 마크다운 | flutter_markdown_plus ^1.0.7 |

---

## 레이어 구조

```
lib/
├── main.dart                        # ProviderScope + runApp
├── app.dart                         # MaterialApp.router + GoRouter 설정 + collectionNavigatorKey
├── theme/app_theme.dart             # Material3 ColorScheme (gold/red)
├── routing/app_routes.dart          # 경로 상수 및 path builder

├── domain/
│   ├── model/                       # @freezed sealed class — 모든 도메인 모델
│   │   ├── board_game.dart          # bggId, name, yearPublished, thumbnail, players, playingTime, isInCollection
│   │   ├── player_score.dart        # id, sessionId, name, score, rank
│   │   ├── session_history.dart     # id, game(BoardGame), scores[], playedAt
│   │   └── judge_history.dart       # id, gameName, question, answer, askedAt
│   └── repository/                  # abstract interface class
│       ├── game_repository.dart
│       ├── session_repository.dart
│       └── rule_judge_repository.dart

├── data/
│   ├── local/                       # Drift ORM
│   │   ├── app_database.dart        # @DriftDatabase, schemaVersion=3
│   │   ├── board_games.dart         # 테이블: bggId PK, name, yearPublished, thumbnail...
│   │   ├── sessions.dart            # 테이블: id auto, bggId FK→board_games
│   │   ├── players.dart             # 테이블: id auto, name UNIQUE
│   │   ├── player_scores.dart       # 테이블: id auto, sessionId FK, playerId FK, score, rank
│   │   ├── judge_histories.dart     # 테이블: id auto, gameName, question, answer, askedAt(ms)
│   │   ├── game_dao.dart
│   │   ├── session_dao.dart
│   │   └── judge_history_dao.dart
│   ├── remote/
│   │   ├── bgg_api_service.dart     # BGG XML API v2
│   │   └── ai/
│   │       ├── llm_client.dart      # abstract: complete(), stream()
│   │       ├── llm_request.dart     # @freezed: systemPrompt, messages[], maxTokens
│   │       └── gemini_llm_client.dart  # Gemini 구현, SSE, 503/429 재시도(지수 백오프)
│   └── repository/                  # 인터페이스 구현체

├── di/
│   ├── database_provider.dart       # appDatabase, gameDao, sessionDao, judgeHistoryDao
│   ├── remote_provider.dart         # dio, bggRemoteDataSource, llmClient
│   └── repository_provider.dart     # gameRepository, sessionRepository, ruleJudgeRepository

└── presentation/
    ├── collection/                  # 게임 컬렉션 탭
    │   ├── game_list_screen.dart    # 컬렉션 목록, BGG 상세 lazy 로딩
    │   ├── game_detail_screen.dart
    │   └── game_search_screen.dart
    ├── score/
    │   └── create_session_screen.dart  # 세션 생성 (플레이어 입력)
    ├── session_tracker/             # 게임 중 점수 입력
    │   └── session_tracker_screen.dart
    ├── session_history/             # 전적 탭
    │   ├── session_history_screen.dart
    │   └── session_history_detail_screen.dart
    └── rule_judge/                  # AI 규칙 판정 탭
        ├── rule_judge_screen.dart   # 스트리밍 응답, 이전 판정 목록
        └── rule_judge_notifier.dart # StreamNotifier<List<String>>
```

---

## DB 스키마 & 마이그레이션

| 버전 | 변경 내용 |
|------|----------|
| 1 | board_games, sessions, players, player_scores 초기 생성 |
| 2 | player_scores.rank 컬럼 추가 + 기존 데이터 rank 계산 |
| 3 | judge_histories 테이블 추가 |

마이그레이션은 `app_database.dart`의 `MigrationStrategy.onUpgrade` 에서 관리.

---

## DI 프로바이더 목록

```dart
// database_provider.dart
appDatabaseProvider         → AppDatabase (keepAlive)
gameDaoProvider             → GameDao
sessionDaoProvider          → SessionDao
judgeHistoryDaoProvider     → JudgeHistoryDao

// remote_provider.dart
dioProvider                 → Dio
bggRemoteDataSourceProvider → BggApiRemoteDataSource
llmClientProvider           → GeminiLlmClient (GEMINI_API_KEY 환경변수 필요)

// repository_provider.dart
gameRepositoryProvider      → GameRepositoryImpl (keepAlive)
sessionRepositoryProvider   → SessionRepositoryImpl (keepAlive)
ruleJudgeRepositoryProvider → RuleJudgeRepositoryImpl (keepAlive)
```

---

## 라우팅 (GoRouter)

4개 탭 — `StatefulShellRoute.indexedStack`:

| 탭 | 경로 | 화면 |
|----|------|------|
| 0 컬렉션 | `/collection` | GameListScreen |
| | `/collection/search` | GameSearchScreen |
| | `/collection/detail/:bggId` | GameDetailScreen |
| | `/collection/create/:bggId` | CreateSessionScreen |
| | `/collection/tracker/:bggId` | SessionTrackerScreen |
| 1 규칙 판정 | `/rule-judge` | RuleJudgeScreen |
| 2 추천 | `/recommend` | RecommendScreen |
| 3 전적 | `/session` | SessionHistoryScreen |
| | `/session/history/:sessionId` | SessionHistoryDetailScreen |

**크로스 탭 네비게이션**: `SessionTrackerScreen`에서 전적 탭으로 이동 시
`context.go(AppRoutes.sessionHistoryLocation(id))`를 호출한 후
`collectionNavigatorKey.currentState?.popUntil((r) => r.isFirst)`로 컬렉션 탭 스택을 초기화.

경로 상수는 `lib/routing/app_routes.dart`의 `AppRoutes` 클래스에 정의.

---

## 주요 패턴

### Riverpod Notifier 작성 방법
```dart
@riverpod
class MyNotifier extends AutoDisposeAsyncNotifier<MyState> {
  @override
  Future<MyState> build() async { ... }
}

// StreamNotifier 예시 (RuleJudgeNotifier)
@riverpod
class RuleJudgeNotifier extends StreamNotifier<List<String>> {
  @override
  Stream<List<String>> build() => Stream.value([]);
}
```

### Freezed 도메인 모델
```dart
@freezed
sealed class MyModel with _$MyModel {
  const factory MyModel({required int id, required String name}) = _MyModel;
}
```

### Drift DAO
```dart
@DriftAccessor(tables: [MyTable])
class MyDao extends DatabaseAccessor<AppDatabase> with _$MyDaoMixin {
  Stream<List<MyRecord>> watchAll() => select(myTable).watch();
}
```

---

## 외부 API

### BoardGameGeek XML API v2
- 기본 URL: `https://boardgamegeek.com/xmlapi2`
- `/search?query=<name>&type=boardgame` — 검색
- `/thing?id=<id1,id2,...>&type=boardgame` — 상세 (최대 20개 배치)
- 인증: `String.fromEnvironment('BGG_API_TOKEN')` (선택)
- 응답: XML → `bgg_xml_parser.dart`에서 파싱

### Google Generative AI (Gemini 2.5 Flash)
- 기본 URL: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash`
- `:generateContent` — 단일 완성
- `:streamGenerateContent?alt=sse` — SSE 스트리밍
- 인증: `x-goog-api-key` 헤더, `String.fromEnvironment('GEMINI_API_KEY')`
- 503/429 발생 시 지수 백오프 재시도 (1s→2s→4s, 최대 3회)
- thinking 파트 (`thought: true`) 자동 필터링

---

## 개발 명령

```bash
# 코드 생성 (Riverpod, Freezed, Drift 전체)
dart run build_runner build --delete-conflicting-outputs

# 앱 실행 (API 키 포함)
flutter run --dart-define=GEMINI_API_KEY=<키>

# 정적 분석
flutter analyze
```

---

## 규칙

- 모든 도메인 모델은 `@freezed sealed class` — 직접 변경 금지, `copyWith` 사용
- 새 테이블 추가 시 `schemaVersion` 증가 + `onUpgrade` 마이그레이션 추가
- Repository 인터페이스는 `domain/repository/`에, 구현체는 `data/repository/`에
- Riverpod provider는 해당 feature의 notifier 파일 또는 `di/` 폴더에 위치
- `.g.dart` / `.freezed.dart` 파일은 직접 편집하지 않음
