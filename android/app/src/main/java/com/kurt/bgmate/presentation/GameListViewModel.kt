package com.kurt.bgmate.presentation

import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.presentation.common.BaseViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import okio.IOException
import retrofit2.HttpException
import javax.inject.Inject

@HiltViewModel
class GameListViewModel @Inject constructor(
    private val repository: GameRepository,
) : BaseViewModel() {

    val games: StateFlow<List<BoardGame>> = repository.observeGames().stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )
    private val _error = MutableStateFlow<String?>(null)
    val error = _error.asStateFlow()

    private val _searchResults = MutableStateFlow<List<BoardGame>>(emptyList())
    val searchResults: StateFlow<List<BoardGame>> = _searchResults.asStateFlow()

    // BottomSheet 표시 여부
    private val _showAddSheet = MutableStateFlow(false)
    val showAddSheet: StateFlow<Boolean> = _showAddSheet.asStateFlow()

    fun openAddSheet() {
        _showAddSheet.value = true
    }

    fun closeAddSheet() {
        _showAddSheet.value = false
    }

    fun addGame(name: String) {
        val trimmedText = name.trim()
        if (trimmedText.isBlank()) return
        if (games.value.any { it.name.equals(trimmedText, ignoreCase = true) }) {
            showMessage("이미 등록된 게임입니다.")
            return
        }
        viewModelScope.launch {
            repository.addGame(trimmedText)
            closeAddSheet()
            showMessage("\"$trimmedText\" 게임이 추가되었습니다.")
        }
    }

    fun addGame(game: BoardGame) {
        if (games.value.any {
                it.bggId == game.bggId || it.name.equals(game.name, ignoreCase = true)
            }) {
            showMessage("이미 등록된 게임입니다.")
            return
        }
        viewModelScope.launch {
            repository.addGame(game)
            showMessage("\"${game.name}\" 게임이 추가되었습니다.")
        }
    }

    fun removeGame(game: BoardGame) {
        viewModelScope.launch {
            repository.removeGame(game.name)
        }
    }

    fun updateGame(old: String, new: String) {
        viewModelScope.launch {
            repository.updateGame(old, new)
        }
    }

    fun search(query: String) {
        if (query.isBlank()) {
            _searchResults.value = emptyList()
            return
        }
        viewModelScope.launch {
            setLoading(true)
            try {
                val response = repository.searchGames(query)
                _searchResults.value = response
            } catch (e: HttpException) {
                _error.value = "서버 오류: ${e.code()}"
            } catch (e: IOException) {
                _error.value = "네트워크 오류: ${e.message}"
            } catch (e: Exception) {
                _error.value = "오류: ${e.message}"
            } finally {
                setLoading(false)
            }
        }
    }

    fun getGameById(id: String?): BoardGame? {
        return games.value.find { it.bggId == id }
    }
}
