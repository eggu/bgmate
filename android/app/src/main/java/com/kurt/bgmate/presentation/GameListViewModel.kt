package com.kurt.bgmate.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.data.remote.BggApiService
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import okio.IOException
import retrofit2.HttpException
import javax.inject.Inject

@HiltViewModel
class GameListViewModel @Inject constructor(
    private val repository: GameRepository,
    private val apiService: BggApiService,
) : ViewModel() {

    private val _games = MutableStateFlow<List<BoardGame>>(emptyList())
    val games: StateFlow<List<BoardGame>> = _games.asStateFlow()
    private val _isLoading = MutableStateFlow(false)
    val isLoading = _isLoading.asStateFlow()
    private val _error = MutableStateFlow<String?>(null)
    val error = _error.asStateFlow()

    private val _searchResults = MutableStateFlow<List<BoardGame>>(emptyList())
    val searchResults: StateFlow<List<BoardGame>> = _searchResults.asStateFlow()


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
        repository.addGame(BoardGame((Math.random() * 10000).toInt().toString(), name))
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
        if (query.isBlank()) {
            _games.value = repository.getGames()
            return
        }
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val response = repository.searchGames(query)
                _searchResults.value = response
                _games.value = response
            } catch (e: HttpException) {
                _error.value = "서버 오류: ${e.code()}"
            } catch (e: IOException) {
                _error.value = "네트워크 오류: ${e.message}"
            } catch (e: Exception) {
                _error.value = "오류: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }

    fun getGameById(id: String?): BoardGame? {
        return _games.value.find { it.id == id }
    }
}


