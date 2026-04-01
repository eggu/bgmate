package com.kurt.bgmate.presentation.scoretracker

import androidx.lifecycle.SavedStateHandle
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.fake.FakeGameRepository
import com.kurt.bgmate.fake.FakeSessionDao
import com.kurt.bgmate.util.MainDispatcherRule
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class ScoreTrackerViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private lateinit var fakeRepository: FakeGameRepository
    private lateinit var fakeSessionDao: FakeSessionDao
    private lateinit var viewModel: ScoreTrackerViewModel

    private val testGame = BoardGame(bggId = "test_id", name = "Catan")

    @Before
    fun setUp() {
        fakeRepository = FakeGameRepository()
        fakeRepository.setGames(listOf(testGame))
        fakeSessionDao = FakeSessionDao()

        val savedStateHandle = SavedStateHandle(mapOf("bggId" to "test_id"))
        viewModel = ScoreTrackerViewModel(fakeSessionDao, fakeRepository, savedStateHandle)
    }

    // ── 초기 상태 ──────────────────────────────────────────────────

    @Test
    fun `초기 상태 - showPlayerSetupSheet는 true다`() {
        assertTrue(viewModel.showPlayerSetupSheet.value)
    }

    @Test
    fun `초기 상태 - pendingPlayerNames는 비어있다`() {
        assertTrue(viewModel.pendingPlayerNames.value.isEmpty())
    }

    @Test
    fun `초기 상태 - isFinished는 false다`() {
        assertFalse(viewModel.isFinished.value)
    }

    // ── addPendingPlayer ───────────────────────────────────────────

    @Test
    fun `addPendingPlayer - 유효한 이름이 목록에 추가된다`() {
        viewModel.addPendingPlayer("Alice")

        assertEquals(listOf("Alice"), viewModel.pendingPlayerNames.value)
    }

    @Test
    fun `addPendingPlayer - 앞뒤 공백이 제거되어 추가된다`() {
        viewModel.addPendingPlayer("  Bob  ")

        assertEquals(listOf("Bob"), viewModel.pendingPlayerNames.value)
    }

    @Test
    fun `addPendingPlayer - 빈 문자열은 무시된다`() {
        viewModel.addPendingPlayer("")

        assertTrue(viewModel.pendingPlayerNames.value.isEmpty())
    }

    @Test
    fun `addPendingPlayer - 공백만 있는 문자열은 무시된다`() {
        viewModel.addPendingPlayer("   ")

        assertTrue(viewModel.pendingPlayerNames.value.isEmpty())
    }

    @Test
    fun `addPendingPlayer - 여러 플레이어를 순서대로 추가할 수 있다`() {
        viewModel.addPendingPlayer("Alice")
        viewModel.addPendingPlayer("Bob")
        viewModel.addPendingPlayer("Charlie")

        assertEquals(listOf("Alice", "Bob", "Charlie"), viewModel.pendingPlayerNames.value)
    }

    // ── removePendingPlayer ────────────────────────────────────────

    @Test
    fun `removePendingPlayer - 해당 인덱스의 플레이어가 제거된다`() {
        viewModel.addPendingPlayer("Alice")
        viewModel.addPendingPlayer("Bob")
        viewModel.addPendingPlayer("Charlie")

        viewModel.removePendingPlayer(1)

        assertEquals(listOf("Alice", "Charlie"), viewModel.pendingPlayerNames.value)
    }

    @Test
    fun `removePendingPlayer - 첫 번째 요소를 제거한다`() {
        viewModel.addPendingPlayer("Alice")
        viewModel.addPendingPlayer("Bob")

        viewModel.removePendingPlayer(0)

        assertEquals(listOf("Bob"), viewModel.pendingPlayerNames.value)
    }

    // ── confirmPlayers ─────────────────────────────────────────────

    @Test
    fun `confirmPlayers - session이 플레이어와 함께 설정된다`() = runTest {
        viewModel.addPendingPlayer("Alice")
        viewModel.addPendingPlayer("Bob")

        viewModel.confirmPlayers()

        val session = viewModel.session.value
        assertNotNull(session)
        assertEquals(2, session!!.players.size)
        assertTrue(session.players.any { it.name == "Alice" })
        assertTrue(session.players.any { it.name == "Bob" })
    }

    @Test
    fun `confirmPlayers - showPlayerSetupSheet가 false가 된다`() {
        viewModel.addPendingPlayer("Alice")

        viewModel.confirmPlayers()

        assertFalse(viewModel.showPlayerSetupSheet.value)
    }

    @Test
    fun `confirmPlayers - session의 game이 올바르게 설정된다`() = runTest {
        viewModel.addPendingPlayer("Alice")

        viewModel.confirmPlayers()

        assertEquals(testGame, viewModel.session.value?.game)
    }

    // ── setScore ───────────────────────────────────────────────────

    @Test
    fun `setScore - 해당 플레이어의 점수가 업데이트된다`() = runTest {
        viewModel.addPendingPlayer("Alice")
        viewModel.addPendingPlayer("Bob")
        viewModel.confirmPlayers()

        val aliceId = viewModel.session.value!!.players.first { it.name == "Alice" }.playerId
        viewModel.setScore(aliceId, 50)

        val alice = viewModel.session.value!!.players.first { it.name == "Alice" }
        assertEquals(50, alice.totalScore)
    }

    @Test
    fun `setScore - 점수 변경 후 내림차순 정렬된다`() = runTest {
        viewModel.addPendingPlayer("Alice")
        viewModel.addPendingPlayer("Bob")
        viewModel.confirmPlayers()

        val players = viewModel.session.value!!.players
        val aliceId = players.first { it.name == "Alice" }.playerId
        val bobId = players.first { it.name == "Bob" }.playerId

        viewModel.setScore(aliceId, 30)
        viewModel.setScore(bobId, 80)

        val sorted = viewModel.session.value!!.players
        assertEquals("Bob", sorted[0].name)
        assertEquals("Alice", sorted[1].name)
    }

    // ── finishSession ──────────────────────────────────────────────

    @Test
    fun `finishSession - SessionDao의 insertSessionWithPlayers가 호출된다`() = runTest {
        viewModel.addPendingPlayer("Alice")
        viewModel.confirmPlayers()

        viewModel.finishSession()

        assertTrue(fakeSessionDao.insertCalled)
    }

    @Test
    fun `finishSession - isFinished가 true가 된다`() = runTest {
        viewModel.addPendingPlayer("Alice")
        viewModel.confirmPlayers()

        viewModel.finishSession()

        assertTrue(viewModel.isFinished.value)
    }

    @Test
    fun `finishSession - session이 null이면 아무것도 하지 않는다`() = runTest {
        // session을 시작하지 않은 상태
        viewModel.finishSession()

        assertFalse(fakeSessionDao.insertCalled)
        assertFalse(viewModel.isFinished.value)
    }
}
