# BGMate Flutter — Claude Code 가이드

보드게임 동반자 앱 (컬렉션 관리, 점수 기록, AI 규칙 판정, AI 게임 추천).

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
├── main.dart                          # ProviderScope + runApp
├── app.dart                           # MaterialApp.router + GoRouter 설정 + collectionNavigatorKey
├── theme/app_theme.dart               # Material3 ColorScheme (gold/red)
├── routing/app_routes.dart            # 경로 상수 및 path builder

├── domain/
│   ├── model/                         # @freezed sealed class — 모든 도메인 모델
│   │   ├── board_game.dart            # bggId, name, yearPublished, thumbnail, players, playingTime
│   │   ├── session.dart               # id, bggId, playedAt
│   │   ├── session_history.dart       # id, game(BoardGame), scores[], playedAt
│   │   ├── player.dart                # id, name
│   │   ├── player_score.dart          # id, sessionId, name, score, rank
│   │   ├── judge_history.dart         # id, gameName, question, answer, askedAt
│   │   ├── judge_result.dart          # answer (thinking part 포함)
│   │   ├── recommend_condition.dart   # playerCount, playTimeMinutes, moods
│   │   ├── recommend_result.dart      # name, reason, isOwned, bggScore, difficulty
│   │   ├── bgg_account.dart           # username, countryName
│   │   ├── collection_status.dart     # Enum: synced/syncing/error/notStarted
│   │   ├── game_source.dart           # Enum: owned/wish
│   │   └── sort_option.dart           # sealed class: SortField(addedAt/name/yearPublished) + SortOrder(asc/desc)
│   └── repository/                    # abstract interface class
│       ├── game_repository.dart
│       ├── session_repository.dart
│       ├── recommend_repository.dart
│       ├── rule_judge_repository.dart
│       └── account_repository.dart

├── data/
│   ├── local/                         # Drift ORM
│   │   ├── app_database.dart          # @DriftDatabase, schemaVersion=3
│   │   ├── board_games.dart           # 테이블: bggId PK, name, yearPublished, thumbnail...
│   │   ├── sessions.dart              # 테이블: id auto, bggId FK→board_games
│   │   ├── players.dart               # 테이블: id auto, name UNIQUE
│   │   ├── player_scores.dart         # 테이블: id auto, sessionId FK, playerId FK, score, rank
│   │   ├── judge_histories.dart       # 테이블: id auto, gameName, question, answer, askedAt(ms)
│   │   ├── connection/
│   │   │   ├── native_connection.dart # 네이티브(Android/iOS/macOS) SQLite 연결
│   │   │   └── web_connection.dart    # Web SQLite3 연결
│   │   ├── game_dao.dart
│   │   ├── session_dao.dart
│   │   ├── player_dao.dart
│   │   ├── judge_history_dao.dart
│   │   ├── session_with_details.dart  # @freezed: UI용 composed model
│   │   ├── record_mapper.dart         # DB record → domain model 변환
│   │   └── game_table_mapper.dart     # board_game DB record → domain 변환
│   ├── remote/
│   │   ├── bgg_remote_data_source.dart      # abstract interface
│   │   ├── bgg_api_remote_data_source.dart  # BGG XML API v2 구현체
│   │   ├── bgg_api_service.dart             # Dio HTTP client wrapper
│   │   ├── bgg_xml_parser.dart              # XML 파싱 로직
│   │   └── ai/
│   │       ├── llm_client.dart        # abstract: complete(), stream()
│   │       ├── llm_request.dart       # @freezed: systemPrompt, messages[], maxTokens
│   │       ├── llm_response.dart      # AI 응답 모델
│   │       └── gemini_llm_client.dart # Gemini 구현, SSE, 503/429 지수 백오프 재시도
│   ├── repository/                    # 인터페이스 구현체
│   │   ├── game_repository_impl.dart
│   │   ├── session_repository_impl.dart
│   │   ├── recommend_repository_impl.dart   # 프롬프트 로딩 + complete 호출 + 결과 파싱
│   │   ├── rule_judge_repository_impl.dart  # 프롬프트 로딩 + stream 호출 + history 저장
│   │   └── account_repository_impl.dart
│   └── service/
│       └── collection_sync_service.dart     # BGG 컬렉션 동기화 로직

├── di/
│   ├── database_provider.dart         # appDatabase, gameDao, sessionDao, playerDao, judgeHistoryDao
│   ├── remote_provider.dart           # dio, bggRemoteDataSource, llmClient
│   ├── repository_provider.dart       # gameRepository, recommendRepository, sessionRepository, ruleJudgeRepository
│   └── account_provider.dart          # accountRepository, bggAccount

└── presentation/
    ├── shell/
    │   └── app_shell.dart             # StatefulShellRoute shell widget (4탭 BottomNavigationBar)
    ├── collection/                    # 게임 컬렉션 탭 (Tab 0)
    │   ├── game_list_screen.dart      # 컬렉션 목록, 정렬 칩(이름/연도/평점), 필터 버튼
    │   ├── game_list_notifier.dart    # AsyncNotifier: 게임 목록 + 정렬/필터 상태
    │   ├── game_detail_screen.dart    # 게임 상세
    │   ├── game_detail_notifier.dart  # AsyncNotifier: BGG 상세 lazy 로딩
    │   ├── game_search_screen.dart    # BGG 검색
    │   ├── search_notifier.dart       # AsyncNotifier: 검색 결과
    │   └── search_debouncer.dart      # 검색 입력 debounce
    ├── score/
    │   ├── create_session_screen.dart     # 세션 생성 (플레이어 입력)
    │   ├── create_session_notifier.dart   # AsyncNotifier: 세션 저장
    │   └── create_session_state.dart      # @freezed: 폼 상태
    ├── session_tracker/               # 게임 중 점수 입력
    │   ├── session_tracker_screen.dart
    │   ├── session_tracker_notifier.dart  # AsyncNotifier: 점수 업데이트
    │   └── player_score_card.dart     # 개별 플레이어 점수 입력 위젯
    ├── session_history/               # 전적 탭 (Tab 3)
    │   ├── session_history_screen.dart
    │   ├── session_history_notifier.dart
    │   ├── session_history_detail_screen.dart
    │   └── session_history_detail_notifier.dart
    ├── rule_judge/                    # AI 규칙 판정 탭 (Tab 1)
    │   ├── rule_judge_screen.dart     # 스트리밍 응답, 이전 판정 목록, 503 친화 메시지
    │   ├── rule_judge_notifier.dart   # StreamNotifier<List<String>>: 스트리밍 응답
    │   └── judge_history_notifier.dart # AsyncNotifier: 이전 판정 기록 로딩
    ├── recommend/                     # AI 추천 탭 (Tab 2)
    │   ├── recommend_screen.dart      # 조건 선택 + 결과 카드/에러/로딩
    │   └── recommend_notifier.dart    # AsyncNotifier<List<RecommendResult>>
    ├── account/
    │   └── account_screen.dart        # BGG 계정 정보, 컬렉션 동기화 상태
    └── widgets/
        └── game_thumbnail.dart        # 재사용 가능한 게임 이미지 위젯
```

---

## DB 스키마 & 마이그레이션

| 버전 | 변경 내용 |
|------|----------|
| 1 | board_games, sessions, players, player_scores 초기 생성 |
| 2 | player_scores.rank 컬럼 추가 + 기존 데이터 rank 계산 |
| 3 | judge_histories 테이블 추가 |

마이그레이션은 `app_database.dart`의 `MigrationStrategy.onUpgrade`에서 관리.

---

## DI 프로바이더 목록

```dart
// database_provider.dart
appDatabaseProvider         → AppDatabase (keepAlive)
gameDaoProvider             → GameDao
sessionDaoProvider          → SessionDao
playerDaoProvider           → PlayerDao
judgeHistoryDaoProvider     → JudgeHistoryDao

// remote_provider.dart
dioProvider                 → Dio
bggRemoteDataSourceProvider → BggApiRemoteDataSource
llmClientProvider           → GeminiLlmClient (GEMINI_API_KEY 환경변수 필요)

// repository_provider.dart
gameRepositoryProvider      → GameRepositoryImpl (keepAlive)
recommendRepositoryProvider → RecommendRepositoryImpl (keepAlive)
sessionRepositoryProvider   → SessionRepositoryImpl (keepAlive)
ruleJudgeRepositoryProvider → RuleJudgeRepositoryImpl (keepAlive)

// account_provider.dart
accountRepositoryProvider   → AccountRepositoryImpl (keepAlive)
bggAccountProvider          → AsyncNotifier<BggAccount?>
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

### 정렬 옵션 (SortOption)
```dart
// sealed class + enum 조합
enum SortField { addedAt, name, yearPublished }
enum SortOrder { asc, desc }

@freezed
sealed class SortOption with _$SortOption {
  const factory SortOption({
    @Default(SortField.addedAt) SortField field,
    @Default(SortOrder.desc) SortOrder order,
  }) = _SortOption;
}

// toggleOrder extension
extension SortOptionX on SortOption {
  SortOption toggleOrder() => copyWith(
        order: order == SortOrder.asc ? SortOrder.desc : SortOrder.asc,
      );
}

// SortField별 비교 로직
extension SortFieldComparator on SortField {
  int compare(BoardGame a, BoardGame b) => switch (this) {
        SortField.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        SortField.yearPublished => a.yearPublished.compareTo(b.yearPublished),
        SortField.addedAt => 0,
      };
}
```

---

## 테스트 목록

```
test/
├── core/image/
│   └── image_url_resolver_test.dart
├── data/remote/
│   ├── bgg_xml_parser_test.dart
│   └── bgg_xml_parser_collection_test.dart
├── data/repository/
│   ├── account_repository_impl_test.dart
│   ├── recommend_repository_test.dart
│   └── recommend_repository_test.mocks.dart
├── data/service/
│   ├── collection_sync_service_test.dart
│   └── collection_sync_service_test.mocks.dart
├── domain/model/
│   └── collection_status_test.dart
└── presentation/
    ├── collection/
    │   ├── game_list_notifier_test.dart
    │   └── search_notifier_test.dart
    ├── recommend/
    │   ├── recommend_notifier_test.dart
    │   └── recommend_screen_test.dart
    └── rule_judge/
        ├── judge_history_notifier_test.dart
        ├── judge_history_notifier_test.mocks.dart
        ├── rule_judge_notifier_test.dart
        ├── rule_judge_notifier_test.mocks.dart
        └── rule_judge_screen_test.dart
```

---

## 외부 API

### BoardGameGeek XML API v2
- 기본 URL: `https://boardgamegeek.com/xmlapi2`
- `/search?query=<name>&type=boardgame` — 검색
- `/thing?id=<id1,id2,...>&type=boardgame` — 상세 (최대 20개 배치)
- `/collection?username=<user>` — 유저 컬렉션 동기화
- 인증: `String.fromEnvironment('BGG_API_TOKEN')` (선택)
- 응답: XML → `bgg_xml_parser.dart`에서 파싱

### Google Generative AI (Gemini 2.5 Flash)
- 기본 URL: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash`
- `:generateContent` — 단일 완성
- `:streamGenerateContent?alt=sse` — SSE 스트리밍
- 인증: `x-goog-api-key` 헤더, `String.fromEnvironment('GEMINI_API_KEY')`
- 503/429 발생 시 지수 백오프 재시도 (1s→2s→4s, 최대 3회)
- thinking 파트 (`thought: true`) 자동 필터링
- UI 503 처리:
  - 추천: `요청이 많아 추천 서버가 잠시 불안정해요. 잠시 후 다시 시도해 주세요.`
  - 규칙 판정: `요청이 많아 규칙 판정 서버가 잠시 불안정해요. 잠시 후 다시 시도해 주세요.`

---

## 개발 명령

```bash
# 코드 생성 (Riverpod, Freezed, Drift 전체)
dart run build_runner build --delete-conflicting-outputs

# 앱 실행 (dart_define.json 사용)
flutter run --dart-define-from-file=dart_define.json

# 정적 분석
flutter analyze

# 핵심 테스트
flutter test test/data/repository/recommend_repository_test.dart
flutter test test/presentation/recommend/recommend_screen_test.dart
flutter test test/presentation/rule_judge/rule_judge_notifier_test.dart
flutter test test/presentation/rule_judge/rule_judge_screen_test.dart
flutter test test/presentation/collection/game_list_notifier_test.dart
```

---

## 규칙

- 모든 도메인 모델은 `@freezed sealed class` — 직접 변경 금지, `copyWith` 사용
- 새 테이블 추가 시 `schemaVersion` 증가 + `onUpgrade` 마이그레이션 추가
- Repository 인터페이스는 `domain/repository/`에, 구현체는 `data/repository/`에
- Riverpod provider는 해당 feature의 notifier 파일 또는 `di/` 폴더에 위치
- `.g.dart` / `.freezed.dart` 파일은 직접 편집하지 않음
- `SortOption`은 sealed class + enum 조합 — 정렬 필드와 순서를 분리해서 관리, `toggleOrder()`로 순서 전환
- 새 정렬 기준 추가 시 `SortField` enum + `SortFieldComparator.compare()` switch 케이스 모두 업데이트
