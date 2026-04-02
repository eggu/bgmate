package com.kurt.bgmate.presentation.rulejudge

import android.util.Log
import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.domain.model.JudgeResult
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.domain.repository.RuleJudgeRepository
import com.kurt.bgmate.presentation.common.BaseViewModel
import com.kurt.bgmate.presentation.rulejudge.RuleJudgeViewModel.UiState.Idle
import com.kurt.bgmate.presentation.rulejudge.RuleJudgeViewModel.UiState.Loading
import com.kurt.bgmate.presentation.rulejudge.RuleJudgeViewModel.UiState.Result
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class RuleJudgeViewModel @Inject constructor(
    private val ruleJudgeRepository: RuleJudgeRepository,
    gameRepository: GameRepository
) :
    BaseViewModel() {

    companion object {
        private const val TAG = "RuleJudgeViewModel"
    }

    sealed interface UiState {
        data object Idle : UiState
        data object Loading : UiState
        data class Result(val text: String) : UiState
        data class Error(val message: String) : UiState
    }

    private val _uiState = MutableStateFlow<UiState>(Idle)
    val uiState: StateFlow<UiState> = _uiState

    private val _streamingText = MutableStateFlow("")
    val streamingText = _streamingText.asStateFlow()

    val history: StateFlow<List<JudgeResult>> = ruleJudgeRepository.observeHistory()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    val games: StateFlow<List<BoardGame>> = gameRepository.observeGames()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    fun judge(gameName: String, dispute: String) {
        if (gameName.isBlank() || dispute.isBlank()) return

        viewModelScope.launch {
            _uiState.update { Loading }
            _streamingText.update { "" }

            ruleJudgeRepository.judge(gameName.trim(), dispute.trim())
                .catch { e ->
                    _uiState.update { UiState.Error(e.message ?: "오류가 발생했습니다.") }
                    Log.e(TAG, "judge: $e", e)
                }
                .collect { chunk ->
                    _streamingText.update { it + chunk }
                    _uiState.update { Result(_streamingText.value) }
                }

            if (uiState.value is UiState.Result)
                ruleJudgeRepository.saveHistory(
                    gameName.trim(),
                    dispute.trim(),
                    streamingText.value
                )
        }
    }

    fun reset() {
        _uiState.update { Idle }
        _streamingText.update { "" }
    }

}
