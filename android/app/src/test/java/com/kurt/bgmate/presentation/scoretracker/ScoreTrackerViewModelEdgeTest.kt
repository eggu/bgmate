package com.kurt.bgmate.presentation.scoretracker

import androidx.lifecycle.SavedStateHandle
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.fake.FakeGameRepository
import com.kurt.bgmate.fake.FakeSessionDao
import com.kurt.bgmate.util.MainDispatcherRule
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class ScoreTrackerViewModelEdgeTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private lateinit var fakeRepository: FakeGameRepository
    private lateinit var fakeSessionDao: FakeSessionDao

    @Before
    fun setUp() {
        fakeRepository = FakeGameRepository()
        fakeSessionDao = FakeSessionDao()
    }

    @Test(expected = IllegalStateException::class)
    fun `초기화 - bggId가 없으면 예외가 발생한다`() {
        ScoreTrackerViewModel(
            sessionDao = fakeSessionDao,
            gameRepository = fakeRepository,
            savedStateHandle = SavedStateHandle()
        )
    }

    @Test
    fun `초기화 - 전달된 bggId로 게임 정보를 로드한다`() = runTest {
        val game = BoardGame(bggId = "loaded_id", name = "Brass")
        fakeRepository.setGames(listOf(game))

        val viewModel = ScoreTrackerViewModel(
            sessionDao = fakeSessionDao,
            gameRepository = fakeRepository,
            savedStateHandle = SavedStateHandle(mapOf("bggId" to "loaded_id"))
        )
        advanceUntilIdle()

        assertEquals(game, viewModel.game.value)
    }

    @Test
    fun `초기화 - 존재하지 않는 bggId면 game은 null이다`() = runTest {
        val viewModel = ScoreTrackerViewModel(
            sessionDao = fakeSessionDao,
            gameRepository = fakeRepository,
            savedStateHandle = SavedStateHandle(mapOf("bggId" to "missing"))
        )
        advanceUntilIdle()

        assertNull(viewModel.game.value)
    }

    @Test(expected = IndexOutOfBoundsException::class)
    fun `removePendingPlayer - 범위를 벗어난 인덱스면 예외가 발생한다`() {
        val viewModel = ScoreTrackerViewModel(
            sessionDao = fakeSessionDao,
            gameRepository = fakeRepository,
            savedStateHandle = SavedStateHandle(mapOf("bggId" to "missing"))
        )

        viewModel.removePendingPlayer(0)
    }

    @Test
    fun `finishSession - 저장 중 예외가 발생하면 완료 상태로 바뀌지 않는다`() = runTest {
        val game = BoardGame(bggId = "test_id", name = "Catan")
        fakeRepository.setGames(listOf(game))
        fakeSessionDao.insertException = RuntimeException("db failure")
        val viewModel = ScoreTrackerViewModel(
            sessionDao = fakeSessionDao,
            gameRepository = fakeRepository,
            savedStateHandle = SavedStateHandle(mapOf("bggId" to "test_id"))
        )
        advanceUntilIdle()
        viewModel.addPendingPlayer("Alice")
        viewModel.confirmPlayers()

        viewModel.finishSession()
        advanceUntilIdle()

        assertFalse(viewModel.isFinished.value)
        assertFalse(viewModel.isLoading.value)
    }

    @Test
    fun `confirmPlayers - 빈 플레이어 목록이어도 시트는 닫히고 빈 세션이 생성된다`() = runTest {
        val game = BoardGame(bggId = "test_id", name = "Catan")
        fakeRepository.setGames(listOf(game))
        val viewModel = ScoreTrackerViewModel(
            sessionDao = fakeSessionDao,
            gameRepository = fakeRepository,
            savedStateHandle = SavedStateHandle(mapOf("bggId" to "test_id"))
        )
        advanceUntilIdle()

        viewModel.confirmPlayers()

        assertFalse(viewModel.showPlayerSetupSheet.value)
        assertTrue(viewModel.session.value?.players?.isEmpty() == true)
    }
}
