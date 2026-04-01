package com.kurt.bgmate.presentation

import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.fake.FakeGameRepository
import com.kurt.bgmate.util.MainDispatcherRule
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class GameListViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private lateinit var fakeRepository: FakeGameRepository
    private lateinit var viewModel: GameListViewModel

    @Before
    fun setUp() {
        fakeRepository = FakeGameRepository()
        viewModel = GameListViewModel(fakeRepository)
    }

    // ── addGame(name) ──────────────────────────────────────────────

    @Test
    fun `addGame - 공백 이름은 repository를 호출하지 않는다`() = runTest {
        viewModel.addGame("   ")

        assertTrue(fakeRepository.addedByNameCalls.isEmpty())
    }

    @Test
    fun `addGame - 빈 문자열은 repository를 호출하지 않는다`() = runTest {
        viewModel.addGame("")

        assertTrue(fakeRepository.addedByNameCalls.isEmpty())
    }

    @Test
    fun `addGame - 유효한 이름은 앞뒤 공백을 제거하고 repository에 전달된다`() = runTest {
        viewModel.addGame("  Pandemic  ")

        assertEquals(listOf("Pandemic"), fakeRepository.addedByNameCalls)
    }

    // ── addGame(BoardGame) ─────────────────────────────────────────

    @Test
    fun `addGame(BoardGame) - repository에 게임 객체가 전달된다`() = runTest {
        val game = BoardGame(bggId = "174430", name = "Gloomhaven")

        viewModel.addGame(game)

        assertEquals(listOf(game), fakeRepository.addedByGameCalls)
    }

    // ── removeGame ─────────────────────────────────────────────────

    @Test
    fun `removeGame - 해당 게임이 repository에서 제거된다`() = runTest {
        val game = BoardGame(bggId = "13", name = "Catan")
        fakeRepository.setGames(listOf(game))

        viewModel.removeGame(game)

        assertEquals(listOf("Catan"), fakeRepository.removedCalls)
    }

    // ── showAddSheet ───────────────────────────────────────────────

    @Test
    fun `openAddSheet - showAddSheet가 true가 된다`() {
        assertFalse(viewModel.showAddSheet.value)

        viewModel.openAddSheet()

        assertTrue(viewModel.showAddSheet.value)
    }

    @Test
    fun `closeAddSheet - showAddSheet가 false가 된다`() {
        viewModel.openAddSheet()
        viewModel.closeAddSheet()

        assertFalse(viewModel.showAddSheet.value)
    }

    // ── search ─────────────────────────────────────────────────────

    @Test
    fun `search - 빈 쿼리는 searchGames를 호출하지 않는다`() = runTest {
        viewModel.search("")

        assertTrue(fakeRepository.searchCalls.isEmpty())
    }

    @Test
    fun `search - 공백만 있는 쿼리는 searchGames를 호출하지 않는다`() = runTest {
        viewModel.search("   ")

        assertTrue(fakeRepository.searchCalls.isEmpty())
    }

    @Test
    fun `search - 유효한 쿼리는 searchResults를 업데이트한다`() = runTest {
        val expected = listOf(
            BoardGame(bggId = "1", name = "Pandemic"),
            BoardGame(bggId = "2", name = "Pandemic Legacy")
        )
        fakeRepository.searchResult = expected

        viewModel.search("pandemic")

        assertEquals(expected, viewModel.searchResults.value)
    }

    @Test
    fun `search - 예외 발생 시 error StateFlow가 업데이트된다`() = runTest {
        fakeRepository.searchException = RuntimeException("네트워크 오류")

        viewModel.search("catan")

        assertTrue(viewModel.error.value?.contains("오류") == true)
    }

    @Test
    fun `search - 완료 후 isLoading이 false로 돌아온다`() = runTest {
        fakeRepository.searchResult = emptyList()

        viewModel.search("catan")

        assertFalse(viewModel.isLoading.value)
    }

    // ── getGameById ────────────────────────────────────────────────

    @OptIn(ExperimentalCoroutinesApi::class)
    @Test
    fun `getGameById - 일치하는 bggId의 게임을 반환한다`() = runTest {
        val game = BoardGame(bggId = "174430", name = "Gloomhaven")
        fakeRepository.setGames(listOf(game))
        // games는 WhileSubscribed라 구독이 있어야 값이 채워짐
        backgroundScope.launch(UnconfinedTestDispatcher()) { viewModel.games.collect {} }

        val result = viewModel.getGameById("174430")

        assertEquals(game, result)
    }

    @Test
    fun `getGameById - null bggId는 null을 반환한다`() {
        val result = viewModel.getGameById(null)

        assertNull(result)
    }

    @Test
    fun `getGameById - 없는 bggId는 null을 반환한다`() = runTest {
        fakeRepository.setGames(listOf(BoardGame(bggId = "1", name = "Catan")))

        val result = viewModel.getGameById("99999")

        assertNull(result)
    }
}
