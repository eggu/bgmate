package com.kurt.bgmate.presentation.recommend

import com.kurt.bgmate.domain.model.Mood
import com.kurt.bgmate.domain.model.PlayTime
import com.kurt.bgmate.domain.model.RecommendCondition
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.presentation.common.BaseViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import javax.inject.Inject

@HiltViewModel
class RecommendViewModel @Inject constructor(
    private val gameRepository: GameRepository
) : BaseViewModel() {

    private val _uiState = MutableStateFlow(RecommendUiState())
    val uiState: StateFlow<RecommendUiState> = _uiState.asStateFlow()

    fun selectPlayerCount(playerCount: Int) {
        _uiState.update { it.copy(selectedPlayerCount = playerCount) }
    }

    fun selectPlayTime(playTime: PlayTime) {
        _uiState.update { it.copy(selectedPlayTime = playTime) }
    }

    fun toggleMood(mood: Mood) {
        _uiState.update { state ->
            val updatedMoods = state.selectedMoods.toMutableSet().apply {
                if (!add(mood)) {
                    remove(mood)
                }
            }
            state.copy(selectedMoods = updatedMoods)
        }
    }

    fun recommend() {
        val state = uiState.value
        val condition = RecommendCondition(
            playerCount = state.selectedPlayerCount ?: return,
            playTimeMinutes = state.selectedPlayTime ?: return,
            moods = state.selectedMoods
        )

        showMessage("추천하기: $condition")
    }
}

data class RecommendUiState(
    val selectedPlayerCount: Int? = null,
    val selectedPlayTime: PlayTime? = null,
    val selectedMoods: Set<Mood> = emptySet(),
) {
    val recommendEnabled: Boolean
        get() = selectedPlayerCount != null &&
                selectedPlayTime != null
}
