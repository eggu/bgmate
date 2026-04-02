package com.kurt.bgmate.presentation.recommend

import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.domain.model.Mood
import com.kurt.bgmate.domain.model.PlayTime
import com.kurt.bgmate.domain.model.RecommendCondition
import com.kurt.bgmate.domain.model.RecommendResult
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.domain.repository.RecommendRepository
import com.kurt.bgmate.presentation.common.BaseViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class RecommendViewModel @Inject constructor(
    private val gameRepository: GameRepository,
    private val recommendRepository: RecommendRepository
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

    fun setIncludeNew(includeNew: Boolean) {
        _uiState.update { it.copy(includeNew = includeNew) }
    }

    fun recommend() {
        val state = uiState.value
        val condition = RecommendCondition(
            playerCount = state.selectedPlayerCount ?: return,
            playTimeMinutes = state.selectedPlayTime ?: return,
            moods = state.selectedMoods
        )

        viewModelScope.launch {
            setLoading(true)
            _uiState.update { it.copy(hasRequested = true) }
            try {
                val games = gameRepository.observeGames().first()

                if (games.isEmpty() && !state.includeNew) {
                    showMessage("컬렉션에 게임을 먼저 추가해주세요.")
                    _uiState.update { it.copy(results = emptyList()) }
                    return@launch
                }

                val results = recommendRepository.recommend(
                    condition = condition,
                    includeNew = state.includeNew,
                    ownedGames = games
                )
                _uiState.update { it.copy(results = results) }
            } catch (_: Exception) {
                showMessage("추천을 가져오지 못했습니다.")
                _uiState.update { it.copy(results = emptyList()) }
            } finally {
                setLoading(false)
            }
        }
    }
}

data class RecommendUiState(
    val selectedPlayerCount: Int? = null,
    val selectedPlayTime: PlayTime? = null,
    val selectedMoods: Set<Mood> = emptySet(),
    val includeNew: Boolean = true,
    val hasRequested: Boolean = false,
    val results: List<RecommendResult> = emptyList(),
) {
    val recommendEnabled: Boolean
        get() = selectedPlayerCount != null &&
            selectedPlayTime != null
}
