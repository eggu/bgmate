# BGMate 프로젝트 구조

## 아키텍처 개요

Clean Architecture 기반 3계층 구조를 따릅니다. 의존성은 단방향으로 흐릅니다.

```
Presentation → Domain ← Data
```

- **Presentation**: UI, ViewModel
- **Domain**: 인터페이스, 도메인 모델 (순수 Kotlin, 외부 의존 없음)
- **Data**: Repository 구현체
- **DI**: Hilt를 사용한 의존성 주입

---

## 패키지 구조

```
com.kurt.bgmate
├── BGMateApp.kt                          # Application 클래스 (@HiltAndroidApp)
├── MainActivity.kt                       # 진입점 Activity
│
├── domain/
│   ├── model/
│   │   └── BoardGame.kt                  # 도메인 모델
│   └── repository/
│       └── GameRepository.kt             # Repository 인터페이스
│
├── data/
│   └── repository/
│       └── GameRepositoryImpl.kt         # Repository 구현체 (인메모리)
│
├── presentation/
│   ├── Screen.kt                         # Navigation 라우트 정의
│   ├── AppNavHost.kt                     # NavHost 설정
│   ├── GameListScreen.kt                 # 게임 목록 화면
│   ├── GameDetailScreen.kt               # 게임 상세/수정 화면
│   └── GameListViewModel.kt              # 게임 목록 ViewModel
│
├── di/
│   └── AppModule.kt                      # Hilt 모듈
│
├── preview/
│   └── PreviewDummy.kt                   # Android Studio Preview용 더미 헬퍼
│
└── ui/theme/
    ├── Color.kt                          # 색상 정의
    ├── Theme.kt                          # Material3 테마
    └── Type.kt                           # Typography 정의
```

---

## 주요 클래스

### Domain

| 클래스 | 종류 | 설명 |
|---|---|---|
| `BoardGame` | `data class` | 보드게임 도메인 모델. 현재 `name: String` 프로퍼티만 보유 |
| `GameRepository` | `interface` | 게임 CRUD 및 조회 계약 정의 |

**GameRepository 메서드**
```kotlin
fun getGames(): List<BoardGame>
fun addGame(name: String)
fun removeGame(name: String)
fun updateGame(old: String, new: String)
suspend fun fetchGames(): List<BoardGame>   // 네트워크 패치 시뮬레이션
fun observeGames(): Flow<List<BoardGame>>   // 실시간 관찰
```

---

### Data

| 클래스 | 종류 | 설명 |
|---|---|---|
| `GameRepositoryImpl` | `class` | `GameRepository` 인메모리 구현체. `@Inject constructor()` |

- 내부에 `mutableListOf<BoardGame>()`으로 상태 유지
- `fetchGames()`: 1초 딜레이 후 50% 확률로 예외 발생 (에러 처리 테스트용)
- `observeGames()`: 3초마다 누적 증가하는 리스트를 emit하는 무한 Flow

---

### Presentation

| 클래스 | 종류 | 설명 |
|---|---|---|
| `GameListViewModel` | `@HiltViewModel` | 게임 목록 상태 관리. `GameRepository` 주입 |
| `GameListScreen` | `@Composable` | 게임 목록 표시, 검색, 삭제 UI |
| `GameDetailScreen` | `@Composable` | 게임 이름 수정 UI |
| `AppNavHost` | `@Composable` | 화면 간 내비게이션 설정 |
| `Screen` | `sealed class` | 내비게이션 라우트 상수 정의 |

**GameListViewModel 상태**
```kotlin
val games: StateFlow<List<BoardGame>>
val isLoading: StateFlow<Boolean>
val error: StateFlow<String?>
```

**GameListViewModel 메서드**
```kotlin
fun addGame(name: String)
fun removeGame(name: String)
fun updateGame(old: String, new: String)
fun search(query: String)
```

**Screen 라우트**
```kotlin
Screen.GameList          // route: "game_list"
Screen.GameDetail(id)    // route: "detail/{id}"
```

---

### DI

| 클래스 | 종류 | 설명 |
|---|---|---|
| `AppModule` | `@Module @InstallIn(SingletonComponent)` | `GameRepository` → `GameRepositoryImpl` 바인딩 (Singleton) |

---

### Preview

| 클래스 | 종류 | 설명 |
|---|---|---|
| `PreviewDummy` | `object` | Hilt 없이 Preview용 `GameListViewModel` 인스턴스를 생성하는 헬퍼 |

---

## 주요 기술 스택

| 항목 | 기술 |
|---|---|
| UI | Jetpack Compose + Material3 |
| 내비게이션 | Navigation Compose |
| 상태 관리 | `StateFlow` + `collectAsStateWithLifecycle` |
| 비동기 | Kotlin Coroutines + Flow |
| DI | Hilt |
| 아키텍처 | Clean Architecture (Domain / Data / Presentation) |
