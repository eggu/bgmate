# BGMate 프로젝트 구조

## 아키텍처 개요

Clean Architecture 기반 3계층 구조를 따릅니다. 의존성은 단방향으로 흐릅니다.

```
Presentation → Domain ← Data
```

- **Presentation**: UI(Jetpack Compose), ViewModel
- **Domain**: 인터페이스, 도메인 모델 (순수 Kotlin, 외부 의존 없음)
- **Data**: Repository 구현체, Room(로컬), Retrofit(원격)
- **DI**: Hilt를 사용한 의존성 주입

---

## 패키지 구조

```
com.kurt.bgmate
├── BGMateApp.kt                                   # Application 클래스 (@HiltAndroidApp)
├── MainActivity.kt                                # 진입점 Activity
│
├── domain/
│   ├── model/
│   │   ├── BoardGame.kt                           # 보드게임 도메인 모델
│   │   ├── JudgeResult.kt                         # 규칙 판정 결과 모델
│   │   ├── PlayerScore.kt                         # 플레이어 점수 모델
│   │   └── ScoreSession.kt                        # 게임 세션 + 플레이어 점수 모델
│   └── repository/
│       ├── GameRepository.kt                      # 게임 CRUD/BGG 검색 인터페이스
│       └── RuleJudgeRepository.kt                 # AI 규칙 판정 인터페이스
│
├── data/
│   ├── local/                                     # Room 데이터베이스
│   │   ├── BoardGameDatabase.kt                   # Room DB 설정
│   │   ├── BoardGameDao.kt                        # 보드게임 DAO
│   │   ├── SessionDao.kt                          # 세션 DAO (트랜잭션 포함)
│   │   ├── JudgeHistoryDao.kt                     # 규칙 판정 기록 DAO
│   │   ├── BoardGameEntity.kt                     # 보드게임 DB 엔티티
│   │   ├── SessionEntity.kt                       # 세션 DB 엔티티
│   │   ├── PlayerEntity.kt                        # 플레이어 DB 엔티티
│   │   ├── ScoreEntryEntity.kt                    # 점수 기록 DB 엔티티
│   │   ├── JudgeHistoryEntity.kt                  # 규칙 판정 기록 DB 엔티티
│   │   └── SessionWithDetails.kt                  # 세션 + 플레이어 + 점수 복합 쿼리 결과
│   ├── remote/                                    # BGG API 통신
│   │   ├── BggRemoteDataSource.kt                 # 원격 데이터 소스 인터페이스
│   │   ├── BggApiRemoteDataSource.kt              # 실제 API 구현체
│   │   ├── BggMockRemoteDataSource.kt             # 테스트용 Mock 구현체
│   │   ├── BggApiService.kt                       # Retrofit API 인터페이스
│   │   ├── BggXmlParser.kt                        # BGG XML 응답 파싱
│   │   └── SearchResponse.kt                      # API 응답 데이터 클래스
│   └── repository/
│       ├── GameRepositoryImpl.kt                  # GameRepository 구현체
│       └── RuleJudgeRepositoryImpl.kt             # RuleJudgeRepository 구현체
│
├── presentation/
│   ├── Screen.kt                                  # Navigation 라우트 정의
│   ├── AppNavHost.kt                              # NavHost 설정
│   ├── BottomNavItem.kt                           # 하단 네비게이션 탭 정의
│   ├── GameListScreen.kt                          # 게임 목록 화면
│   ├── GameDetailScreen.kt                        # 게임 상세 화면
│   ├── GameListViewModel.kt                       # 게임 목록 ViewModel
│   ├── common/                                    # 공통 UI 컴포넌트
│   │   ├── BaseViewModel.kt                       # 로딩/이벤트 공통 ViewModel
│   │   ├── UiEvent.kt                             # UI 이벤트 sealed interface
│   │   ├── LoadingOverlay.kt                      # 로딩 오버레이 Composable
│   │   └── ObserveUiEvents.kt                     # UiEvent 구독 헬퍼 Composable
│   ├── rulejudge/                                 # 규칙 판정관 기능
│   │   ├── RuleJudgeScreen.kt                     # 규칙 판정 화면
│   │   └── RuleJudgeViewModel.kt                  # 규칙 판정 ViewModel
│   ├── scoretracker/                              # 점수 추적 기능
│   │   ├── ScoreTrackerScreen.kt                  # 점수 추적 화면
│   │   ├── ScoreTrackerViewModel.kt               # 점수 추적 ViewModel
│   │   ├── ScoreInputContent.kt                   # 점수 입력 Composable
│   │   └── ScoreResultContent.kt                  # 점수 결과 Composable
│   └── history/                                   # 전적 기록 기능
│       ├── SessionHistoryScreen.kt                # 전적 목록 화면
│       ├── SessionHistoryViewModel.kt             # 전적 목록 ViewModel
│       └── SessionDetailScreen.kt                 # 전적 상세 화면
│
├── di/
│   └── AppModule.kt                               # Hilt 모듈
│
├── preview/
│   └── PreviewDummy.kt                            # Android Studio Preview용 더미 헬퍼
│
└── ui/theme/
    ├── Color.kt                                   # 색상 정의
    ├── Theme.kt                                   # Material3 테마
    └── Type.kt                                    # Typography 정의
```

---

## 주요 클래스

### Domain

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BoardGame` | `data class` | 보드게임 도메인 모델. `bggId`, `name`, `yearPublished?`, `thumbnailUrl?` |
| `JudgeResult` | `data class` | 규칙 판정 결과. `id`, `gameName`, `dispute`, `answer`, `askedAt` |
| `PlayerScore` | `data class` | 플레이어 점수. `playerId`, `name`, `totalScore` |
| `ScoreSession` | `data class` | 게임 세션. `sessionId`, `game`, `players`, `playedAt` |
| `GameRepository` | `interface` | 게임 CRUD, BGG 검색, 세션 조회 계약 정의 |
| `RuleJudgeRepository` | `interface` | AI 규칙 판정 및 판정 기록 계약 정의 |

**GameRepository 메서드**
```kotlin
fun getGames(): List<BoardGame>
suspend fun addGame(name: String)
suspend fun removeGame(name: String)
suspend fun updateGame(old: String, new: String)
suspend fun searchGames(query: String): List<BoardGame>   // BGG API 검색
suspend fun getGameById(id: String): BoardGame?
fun observeGames(): Flow<List<BoardGame>>                 // 로컬 DB 실시간 관찰
fun observeSessionHistory(): Flow<List<ScoreSession>>     // 세션 기록 실시간 관찰
suspend fun getSessionById(sessionId: Long): ScoreSession?
```

**RuleJudgeRepository 메서드**
```kotlin
fun judge(gameName: String, dispute: String): Flow<String>   // AI 판정 (스트리밍)
suspend fun saveHistory(gameName: String, dispute: String, answer: String)
fun observeHistory(): Flow<List<JudgeResult>>                // 판정 기록 실시간 관찰
```

---

### Data

#### Local (Room)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BoardGameDatabase` | `@Database` | Room DB. `BoardGameDao`, `SessionDao`, `JudgeHistoryDao` 포함 |
| `BoardGameDao` | `@Dao` | 보드게임 CRUD |
| `SessionDao` | `@Dao` | 세션/플레이어/점수 삽입 및 조회. `@Transaction insertSessionWithPlayers()` 제공 |
| `JudgeHistoryDao` | `@Dao` | 규칙 판정 기록 삽입 및 조회 |
| `SessionWithDetails` | `data class` | `@Relation`으로 세션 + 플레이어 + 점수를 한 번에 조회하는 복합 결과 |

#### Remote (BGG API)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BggRemoteDataSource` | `interface` | 원격 데이터 소스 계약 |
| `BggApiRemoteDataSource` | `class` | 실제 API 호출 및 파싱 결과를 도메인 모델로 변환 |
| `BggMockRemoteDataSource` | `class` | 테스트/개발용 Mock 데이터 소스 |
| `BggApiService` | Retrofit `interface` | BoardGameGeek XML API v2 호출 |
| `BggXmlParser` | `object` | XML 문자열을 `BoardGame` 리스트로 파싱 |

#### Repository

| 클래스 | 종류 | 설명 |
|---|---|---|
| `GameRepositoryImpl` | `class` | `GameRepository` 구현체. Room + BGG API 통합 |
| `RuleJudgeRepositoryImpl` | `class` | `RuleJudgeRepository` 구현체. Claude AI API + Room 통합 |

---

### Presentation

#### 공통 (common/)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BaseViewModel` | `abstract class` | 로딩 상태(`isLoading`)와 UI 이벤트(`uiEvent`) 공통 관리 |
| `UiEvent` | `sealed interface` | UI 이벤트 타입 정의. `ShowMessage(message)` |
| `LoadingOverlay` | `@Composable` | 전체 화면 로딩 오버레이 |
| `ObserveUiEvents` | `@Composable` | `BaseViewModel.uiEvent`를 구독해 스낵바 등을 처리하는 헬퍼 |

#### 게임 목록

| 클래스 | 종류 | 설명 |
|---|---|---|
| `GameListViewModel` | `@HiltViewModel` | 게임 목록, BGG 검색, 게임 추가/수정/삭제 |
| `GameListScreen` | `@Composable` | 게임 목록 + BGG 검색 결과 표시, BottomSheet로 게임 추가 |
| `GameDetailScreen` | `@Composable` | 게임 상세 정보 표시 |

**GameListViewModel 상태**
```kotlin
val games: StateFlow<List<BoardGame>>          // 로컬 저장 게임 목록 (Room Flow)
val searchResults: StateFlow<List<BoardGame>>  // BGG 검색 결과
val isLoading: StateFlow<Boolean>
val error: StateFlow<String?>
val showAddSheet: StateFlow<Boolean>           // 게임 추가 BottomSheet 표시
```

#### 규칙 판정관 (rulejudge/)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `RuleJudgeViewModel` | `@HiltViewModel` | AI 판정 요청, 스트리밍 텍스트 관리, 판정 기록 조회 |
| `RuleJudgeScreen` | `@Composable` | 규칙 판정 요청 및 결과/기록 표시 화면 |

**RuleJudgeViewModel 상태**
```kotlin
val uiState: StateFlow<UiState>          // Idle | Loading | Result(text) | Error(message)
val streamingText: StateFlow<String>     // 스트리밍 중인 판정 텍스트
val history: StateFlow<List<JudgeResult>> // 과거 판정 기록
```

#### 점수 추적 (scoretracker/)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `ScoreTrackerViewModel` | `@HiltViewModel` | 세션 상태 관리, 점수 입력, 세션 저장 |
| `ScoreTrackerScreen` | `@Composable` | 점수 추적 메인 화면 |
| `ScoreInputContent` | `@Composable` | 플레이어별 점수 입력 UI |
| `ScoreResultContent` | `@Composable` | 게임 종료 후 결과 표시 |

**ScoreTrackerViewModel 상태**
```kotlin
val game: StateFlow<BoardGame?>                      // 현재 추적 중인 게임
val session: StateFlow<ScoreSession?>                // 현재 세션 (플레이어 + 점수)
val isLoading: StateFlow<Boolean>
val isFinished: StateFlow<Boolean>                   // 세션 저장 완료 여부
val showPlayerSetupSheet: StateFlow<Boolean>         // 플레이어 설정 BottomSheet
val pendingPlayerNames: StateFlow<List<String>>      // 입력 중인 플레이어 이름 목록
```

#### 전적 기록 (history/)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `SessionHistoryViewModel` | `@HiltViewModel` | 전적 목록을 Flow로 관찰 |
| `SessionHistoryScreen` | `@Composable` | 전적 목록 화면 |
| `SessionDetailScreen` | `@Composable` | 세션 상세 화면 (플레이어별 점수, 순위) |

#### Navigation

**BottomNavItem 탭**
```kotlin
BottomNavItem.Collection    // 컬렉션 탭 → Screen.GAME_LIST
BottomNavItem.RuleJudge     // 규칙 판정관 탭 → Screen.RULE_JUDGE
BottomNavItem.History       // 전적 기록 탭 → Screen.SESSION_HISTORY
```

**Screen 라우트**
```kotlin
Screen.GAME_LIST                        // "game_list"
Screen.GAME_DETAIL / gameDetail(id)     // "detail/{id}"
Screen.SCORE_TRACKER / scoreTracker(id) // "score_tracker/{bggId}"
Screen.RULE_JUDGE                       // "rule_judge"
Screen.SESSION_HISTORY                  // "session_history"
Screen.SESSION_DETAIL / sessionDetail(sessionId) // "session_detail/{sessionId}"
```

---

### DI

| 클래스 | 종류 | 설명 |
|---|---|---|
| `AppModule` | `@Module @InstallIn(SingletonComponent)` | Room DB, DAO, Retrofit, Repository 바인딩 |

---

### Preview

| 클래스 | 종류 | 설명 |
|---|---|---|
| `PreviewDummy` | `object` | Hilt 없이 Preview용 ViewModel 인스턴스를 생성하는 헬퍼 |

---

## 주요 기술 스택

| 항목 | 기술 |
|---|---|
| UI | Jetpack Compose + Material3 |
| 내비게이션 | Navigation Compose (Bottom Navigation) |
| 상태 관리 | `StateFlow` + `collectAsStateWithLifecycle` |
| 비동기 | Kotlin Coroutines + Flow |
| DI | Hilt |
| 로컬 DB | Room |
| 네트워크 | Retrofit2 + OkHttp (BGG XML API) |
| AI | Claude API (규칙 판정, 스트리밍) |
| 아키텍처 | Clean Architecture (Domain / Data / Presentation) |
