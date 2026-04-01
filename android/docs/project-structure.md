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
│   │   ├── PlayerScore.kt                         # 플레이어 점수 모델
│   │   └── ScoreSession.kt                        # 게임 세션 + 플레이어 점수 모델
│   └── repository/
│       └── GameRepository.kt                      # Repository 인터페이스
│
├── data/
│   ├── local/                                     # Room 데이터베이스
│   │   ├── BoardGameDatabase.kt                   # Room DB 설정
│   │   ├── BoardGameDao.kt                        # 보드게임 DAO
│   │   ├── SessionDao.kt                          # 세션 DAO (트랜잭션 포함)
│   │   ├── BoardGameEntity.kt                     # 보드게임 DB 엔티티
│   │   ├── SessionEntity.kt                       # 세션 DB 엔티티
│   │   ├── PlayerEntity.kt                        # 플레이어 DB 엔티티
│   │   ├── ScoreEntryEntity.kt                    # 점수 기록 DB 엔티티
│   │   └── SessionWithDetails.kt                  # 세션 + 플레이어 + 점수 복합 쿼리 결과
│   ├── remote/                                    # BGG API 통신
│   │   ├── BggApiService.kt                       # Retrofit API 인터페이스
│   │   ├── BggRemoteDataSource.kt                 # 원격 데이터 소스
│   │   ├── BggXmlParser.kt                        # BGG XML 응답 파싱
│   │   └── SearchResponse.kt                      # API 응답 데이터 클래스
│   └── repository/
│       └── GameRepositoryImpl.kt                  # GameRepository 구현체
│
├── presentation/
│   ├── Screen.kt                                  # Navigation 라우트 정의
│   ├── AppNavHost.kt                              # NavHost 설정
│   ├── GameListScreen.kt                          # 게임 목록 화면
│   ├── GameDetailScreen.kt                        # 게임 상세 화면
│   ├── GameListViewModel.kt                       # 게임 목록 ViewModel
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
| `PlayerScore` | `data class` | 플레이어 점수. `playerId`, `name`, `totalScore` |
| `ScoreSession` | `data class` | 게임 세션. `sessionId`, `game`, `players`, `playedAt` |
| `GameRepository` | `interface` | 게임 CRUD, BGG 검색, 세션 조회 계약 정의 |

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

---

### Data

#### Local (Room)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BoardGameDatabase` | `@Database` | Room DB. `BoardGameDao`, `SessionDao` 포함 |
| `BoardGameDao` | `@Dao` | 보드게임 CRUD |
| `SessionDao` | `@Dao` | 세션/플레이어/점수 삽입 및 조회. `@Transaction insertSessionWithPlayers()` 제공 |
| `SessionWithDetails` | `data class` | `@Relation`으로 세션 + 플레이어 + 점수를 한 번에 조회하는 복합 결과 |

#### Remote (BGG API)

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BggApiService` | Retrofit `interface` | BoardGameGeek XML API v2 호출 |
| `BggRemoteDataSource` | `class` | API 호출 및 파싱 결과를 도메인 모델로 변환 |
| `BggXmlParser` | `object` | XML 문자열을 `BoardGame` 리스트로 파싱 |

#### Repository

| 클래스 | 종류 | 설명 |
|---|---|---|
| `GameRepositoryImpl` | `class` | `GameRepository` 구현체. Room + BGG API 통합 |

---

### Presentation

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

**Screen 라우트**
```kotlin
Screen.GameList                      // route: "game_list"
Screen.GameDetail(id)                // route: "detail/{id}"
Screen.ScoreTracker(bggId)           // route: "score_tracker/{bggId}"
Screen.SessionHistory                // route: "session_history"
Screen.SessionDetail(sessionId)      // route: "session_detail/{sessionId}"
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
| 내비게이션 | Navigation Compose |
| 상태 관리 | `StateFlow` + `collectAsStateWithLifecycle` |
| 비동기 | Kotlin Coroutines + Flow |
| DI | Hilt |
| 로컬 DB | Room |
| 네트워크 | Retrofit2 + OkHttp (BGG XML API) |
| 아키텍처 | Clean Architecture (Domain / Data / Presentation) |
