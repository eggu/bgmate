package com.kurt.bgmate.presentation.recommend

import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.Mood
import com.kurt.bgmate.domain.model.PlayTime
import com.kurt.bgmate.domain.model.RecommendCondition
import com.kurt.bgmate.domain.model.RecommendResult
import com.kurt.bgmate.fake.FakeGameRepository
import com.kurt.bgmate.fake.FakeRecommendRepository
import com.kurt.bgmate.presentation.common.UiEvent
import com.kurt.bgmate.util.MainDispatcherRule
import kotlinx.coroutines.async
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class RecommendViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private lateinit var fakeGameRepository: FakeGameRepository
    private lateinit var fakeRecommendRepository: FakeRecommendRepository
    private lateinit var viewModel: RecommendViewModel

    @Before
    fun setUp() {
        fakeGameRepository = FakeGameRepository()
        fakeRecommendRepository = FakeRecommendRepository()
        viewModel = RecommendViewModel(
            gameRepository = fakeGameRepository,
            recommendRepository = fakeRecommendRepository
        )
    }

    @Test
    fun `selectPlayerCount - 선택한 인원수가 uiState에 반영된다`() {
        viewModel.selectPlayerCount(4)

        assertEquals(4, viewModel.uiState.value.selectedPlayerCount)
    }

    @Test
    fun `selectPlayTime - 선택한 플레이 시간이 uiState에 반영된다`() {
        viewModel.selectPlayTime(PlayTime.MEDIUM)

        assertEquals(PlayTime.MEDIUM, viewModel.uiState.value.selectedPlayTime)
    }

    @Test
    fun `toggleMood - 없는 분위기를 선택하면 추가된다`() {
        viewModel.toggleMood(Mood.PARTY)

        assertEquals(setOf(Mood.PARTY), viewModel.uiState.value.selectedMoods)
    }

    @Test
    fun `toggleMood - 이미 선택한 분위기를 다시 누르면 제거된다`() {
        viewModel.toggleMood(Mood.PARTY)
        viewModel.toggleMood(Mood.PARTY)

        assertTrue(viewModel.uiState.value.selectedMoods.isEmpty())
    }

    @Test
    fun `setIncludeNew - includeNew 상태가 변경된다`() {
        assertTrue(viewModel.uiState.value.includeNew)

        viewModel.setIncludeNew(false)

        assertFalse(viewModel.uiState.value.includeNew)
    }

    @Test
    fun `recommend - 성공 시 현재 조건으로 recommendRepository를 호출한다`() = runTest {
        val ownedGames = listOf(BoardGame(bggId = "1", name = "스플렌더"))
        fakeGameRepository.setGames(ownedGames)
        fakeRecommendRepository.recommendResult = listOf(
            RecommendResult(
                name = "스플렌더",
                reason = "전략적인 선택이 잘 맞습니다.",
                isOwned = true
            )
        )
        viewModel.selectPlayerCount(4)
        viewModel.selectPlayTime(PlayTime.MEDIUM)
        viewModel.toggleMood(Mood.STRATEGY)
        viewModel.setIncludeNew(false)

        viewModel.recommend()
        advanceUntilIdle()

        assertEquals(1, fakeRecommendRepository.recommendCalls.size)
        assertEquals(
            RecommendCondition(
                playerCount = 4,
                playTimeMinutes = PlayTime.MEDIUM,
                moods = setOf(Mood.STRATEGY)
            ),
            fakeRecommendRepository.recommendCalls.single().condition
        )
        assertFalse(fakeRecommendRepository.recommendCalls.single().includeNew)
        assertEquals(ownedGames, fakeRecommendRepository.recommendCalls.single().ownedGames)
    }

    @Test
    fun `recommend - 성공 시 결과가 uiState에 반영된다`() = runTest {
        val expected = listOf(
            RecommendResult(
                name = "코드네임",
                reason = "파티와 전략 요소를 함께 즐기기 좋습니다.",
                isOwned = false,
                bggScore = 7.6f,
                difficulty = "쉬움"
            )
        )
        fakeRecommendRepository.recommendResult = expected
        viewModel.selectPlayerCount(6)
        viewModel.selectPlayTime(PlayTime.SHORT)

        viewModel.recommend()
        advanceUntilIdle()

        assertTrue(viewModel.uiState.value.hasRequested)
        assertEquals(expected, viewModel.uiState.value.results)
        assertFalse(viewModel.isLoading.value)
    }

    @Test
    fun `recommend - 보유 게임이 없고 includeNew가 false면 안내 메시지를 보낸다`() = runTest {
        viewModel.selectPlayerCount(3)
        viewModel.selectPlayTime(PlayTime.MEDIUM)
        viewModel.setIncludeNew(false)
        val event = backgroundScope.async(UnconfinedTestDispatcher(testScheduler)) {
            viewModel.uiEvent.first()
        }

        viewModel.recommend()
        advanceUntilIdle()

        assertEquals(
            UiEvent.ShowMessage("컬렉션에 게임을 먼저 추가해주세요."),
            event.await()
        )
        assertTrue(fakeRecommendRepository.recommendCalls.isEmpty())
        assertTrue(viewModel.uiState.value.results.isEmpty())
    }

    @Test
    fun `recommend - recommendRepository 예외 발생 시 실패 메시지를 보낸다`() = runTest {
        fakeRecommendRepository.recommendException = RuntimeException("API 오류")
        viewModel.selectPlayerCount(2)
        viewModel.selectPlayTime(PlayTime.LONG)
        val event = backgroundScope.async(UnconfinedTestDispatcher(testScheduler)) {
            viewModel.uiEvent.first()
        }

        viewModel.recommend()
        advanceUntilIdle()

        assertEquals(
            UiEvent.ShowMessage("추천을 가져오지 못했습니다."),
            event.await()
        )
        assertTrue(viewModel.uiState.value.results.isEmpty())
        assertFalse(viewModel.isLoading.value)
    }
}
