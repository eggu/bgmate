package com.kurt.bgmate.presentation

import com.kurt.bgmate.fake.FakeRuleJudgeRepository
import com.kurt.bgmate.presentation.rulejudge.RuleJudgeViewModel
import com.kurt.bgmate.util.MainDispatcherRule
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class RuleJudgeViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private lateinit var fakeRepository: FakeRuleJudgeRepository
    private lateinit var viewModel: RuleJudgeViewModel

    @Before
    fun setUp() {
        fakeRepository = FakeRuleJudgeRepository()
        viewModel = RuleJudgeViewModel(fakeRepository)
    }

    // ── judge 입력 방어 ────────────────────────────────────────────

    @Test
    fun `judge - 빈 gameName은 상태를 변경하지 않는다`() = runTest {
        viewModel.judge("", "규칙 분쟁 상황")

        assertTrue(viewModel.uiState.value is RuleJudgeViewModel.UiState.Idle)
    }

    @Test
    fun `judge - 빈 dispute는 상태를 변경하지 않는다`() = runTest {
        viewModel.judge("Catan", "")

        assertTrue(viewModel.uiState.value is RuleJudgeViewModel.UiState.Idle)
    }

    @Test
    fun `judge - 공백만 있는 gameName은 상태를 변경하지 않는다`() = runTest {
        viewModel.judge("   ", "분쟁 상황")

        assertTrue(viewModel.uiState.value is RuleJudgeViewModel.UiState.Idle)
    }

    // ── judge 정상 흐름 ────────────────────────────────────────────

    @Test
    fun `judge - 성공 시 UiState가 Result로 전환된다`() = runTest {
        fakeRepository.judgeChunks = listOf("판정 결과입니다.")

        viewModel.judge("Catan", "주사위를 굴릴 수 있나요?")

        assertTrue(viewModel.uiState.value is RuleJudgeViewModel.UiState.Result)
    }

    @Test
    fun `judge - 청크가 streamingText에 누적된다`() = runTest {
        fakeRepository.judgeChunks = listOf("첫 번째", " 두 번째", " 세 번째")

        viewModel.judge("Catan", "분쟁 상황")

        assertEquals("첫 번째 두 번째 세 번째", viewModel.streamingText.value)
    }

    @Test
    fun `judge - 성공 시 saveHistory가 호출된다`() = runTest {
        fakeRepository.judgeChunks = listOf("판정 완료")

        viewModel.judge("Pandemic", "카드를 뽑을 수 있나요?")

        assertEquals(1, fakeRepository.savedHistories.size)
        val (gameName, dispute, _) = fakeRepository.savedHistories[0]
        assertEquals("Pandemic", gameName)
        assertEquals("카드를 뽑을 수 있나요?", dispute)
    }

    // ── judge 실패 흐름 ────────────────────────────────────────────

    @Test
    fun `judge - Flow 예외 발생 시 UiState가 Error로 전환된다`() = runTest {
        fakeRepository.judgeException = RuntimeException("API 오류")

        viewModel.judge("Catan", "분쟁 상황")

        assertTrue(viewModel.uiState.value is RuleJudgeViewModel.UiState.Error)
    }

    @Test
    fun `judge - 실패 시 saveHistory가 호출되지 않는다`() = runTest {
        fakeRepository.judgeException = RuntimeException("네트워크 오류")

        viewModel.judge("Catan", "분쟁 상황")

        assertTrue(fakeRepository.savedHistories.isEmpty())
    }

    // ── reset ──────────────────────────────────────────────────────

    @Test
    fun `reset - UiState가 Idle로 초기화된다`() = runTest {
        fakeRepository.judgeChunks = listOf("결과")
        viewModel.judge("Catan", "분쟁 상황")

        viewModel.reset()

        assertTrue(viewModel.uiState.value is RuleJudgeViewModel.UiState.Idle)
    }

    @Test
    fun `reset - streamingText가 빈 문자열로 초기화된다`() = runTest {
        fakeRepository.judgeChunks = listOf("결과 텍스트")
        viewModel.judge("Catan", "분쟁 상황")

        viewModel.reset()

        assertEquals("", viewModel.streamingText.value)
    }
}
