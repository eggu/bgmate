package com.kurt.bgmate

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class GameListViewModel @Inject constructor(private val repository: GameRepository) : ViewModel() {

    private val _games = MutableStateFlow<List<String>>(emptyList())
    val games: StateFlow<List<String>> = _games.asStateFlow()
    private val _isLoading = MutableStateFlow(false)
    val isLoading = _isLoading.asStateFlow()
    private val _error = MutableStateFlow<String?>(null)
    val error = _error.asStateFlow()
//    val games = repository.observeGames()
//        .stateIn(
//            scope = viewModelScope,
//            started = SharingStarted.WhileSubscribed(5000),
//            initialValue = emptyList()
//        )


    fun addGame(name: String) {
        val trimmedText = name.trim()
        if (trimmedText.isBlank()) return
        repository.addGame(trimmedText)
        _games.value = repository.getGames()
    }

    fun removeGame(name: String) {
        repository.removeGame(name)
        _games.value = repository.getGames()
    }

    fun updateGame(old: String, new: String) {
        val trimmed = new.trim()
        if (trimmed.isBlank()) return
        repository.updateGame(old, trimmed)
        _games.value = repository.getGames()
    }

    fun onClickLoad() {
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
}