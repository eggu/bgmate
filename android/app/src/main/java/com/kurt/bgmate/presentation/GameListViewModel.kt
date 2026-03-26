package com.kurt.bgmate.presentation

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class GameListViewModel @Inject constructor(
    private val repository: GameRepository
) : ViewModel() {

    private val _games = MutableStateFlow<List<BoardGame>>(emptyList())
    val games: StateFlow<List<BoardGame>> = _games.asStateFlow()
    private val _isLoading = MutableStateFlow(false)
    val isLoading = _isLoading.asStateFlow()
    private val _error = MutableStateFlow<String?>(null)
    val error = _error.asStateFlow()

    init {
        viewModelScope.launch {
            _isLoading.value = true
            _error.value = null
            try {
                _games.value = repository.fetchGames()
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                _isLoading.value = false
            }
        }
    }

    fun addGame(name: String) {
        val trimmedText = name.trim()
        if (trimmedText.isBlank()) return
        repository.addGame(BoardGame((Math.random() * 10000).toInt(), name))
        _games.value = repository.getGames()
    }

    fun removeGame(game: BoardGame) {
        repository.removeGame(game)
        _games.value = repository.getGames()
    }

    fun updateGame(updatedGame: BoardGame) {
        repository.updateGame(updatedGame)
        _games.value = repository.getGames()
    }

    fun search(query: String) {
        Log.d("debounce", "검색어: $query")
    }

    fun getGameById(id: Int?): BoardGame? {
        return _games.value.find { it.id == id }
    }
}

