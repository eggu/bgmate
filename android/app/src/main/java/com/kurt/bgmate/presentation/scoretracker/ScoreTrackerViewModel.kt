package com.kurt.bgmate.presentation.scoretracker

import android.util.Log
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.data.local.SessionDao
import com.kurt.bgmate.data.local.toPlayerEntity
import com.kurt.bgmate.data.local.toScoreEntryEntity
import com.kurt.bgmate.data.local.toSessionEntity
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.PlayerScore
import com.kurt.bgmate.domain.model.ScoreSession
import com.kurt.bgmate.domain.repository.GameRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ScoreTrackerViewModel @Inject constructor(
    private val sessionDao: SessionDao,
    val gameRepository: GameRepository,
    savedStateHandle: SavedStateHandle,
) : ViewModel() {

    companion object {
        const val TAG = "ScoreTrackerViewModel"
    }

    // Navigation 라우트에서 bggId 추출
    private val bggId: String = checkNotNull(savedStateHandle["bggId"])

    private val _game = MutableStateFlow<BoardGame?>(null)
    val game: StateFlow<BoardGame?> = _game.asStateFlow()

    private val _session = MutableStateFlow<ScoreSession?>(null)
    val session: StateFlow<ScoreSession?> = _session.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _isFinished = MutableStateFlow(false)
    val isFinished: StateFlow<Boolean> = _isFinished.asStateFlow()

    init {
        Log.d("ScoreTrackerViewModel", "ScoreTrackerViewModel initialized: $bggId")
        // ViewModel 생성 시점에 게임 정보 로드
        viewModelScope.launch {
            _game.update { gameRepository.getGameById(bggId) }
        }
    }

    fun startSession(playerNames: List<String>) {
        _game.value?.let { game ->
            _session.update {
                ScoreSession(
                    game = game,
                    players = playerNames.mapIndexed { index, name ->
                        PlayerScore(
                            playerId = index.toLong(),
                            name = name
                        )
                    }
                )
            }
        }
    }

    fun setScore(playerId: Long, score: Int) {
        _session.update { current ->
            current?.copy(
                players = current.players.map { player ->
                    if (player.playerId == playerId) {
                        player.copy(totalScore = score)
                    } else player
                }.sortedByDescending { it.totalScore }
            )
        }
    }

    fun finishSession() {
        val current = _session.value ?: return
        viewModelScope.launch {
            _isLoading.update { true }
            try {
                sessionDao.insertSessionWithPlayers(
                    session = current.toSessionEntity(),
                    players = current.players.map { it.toPlayerEntity(0) },
                    scores = current.players.map { it.toScoreEntryEntity(0) }
                )
                _isFinished.update { true }
            } catch (e: Exception) {
                Log.e(TAG, "저장 실패", e)
            } finally {
                _isLoading.update { false }
            }
        }
    }


    // 플레이어 이름 입력 시트 표시 여부
    private val _showPlayerSetupSheet = MutableStateFlow(true)  // 진입 시 바로 열림
    val showPlayerSetupSheet: StateFlow<Boolean> = _showPlayerSetupSheet.asStateFlow()

    // 임시 플레이어 이름 목록 (입력 중 상태)
    private val _pendingPlayerNames = MutableStateFlow<List<String>>(emptyList())
    val pendingPlayerNames: StateFlow<List<String>> = _pendingPlayerNames.asStateFlow()

    fun addPendingPlayer(name: String) {
        if (name.isBlank()) return
        _pendingPlayerNames.update { it + name.trim() }
    }

    fun removePendingPlayer(index: Int) {
        _pendingPlayerNames.update { it.toMutableList().also { list -> list.removeAt(index) } }
    }

    fun confirmPlayers() {
        startSession(_pendingPlayerNames.value)
        _showPlayerSetupSheet.update { false }
    }
}