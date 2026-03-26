package com.kurt.bgmate

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class GameListViewModel @Inject constructor(private val repository: GameRepository) : ViewModel() {

    private val _games = MutableStateFlow<List<String>>(emptyList())
//    val games: StateFlow<List<String>> = _games.asStateFlow()
    private val _isLoading = MutableStateFlow(false)
    val isLoading = _isLoading.asStateFlow()
    val games = repository.observeGames()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )


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
            _games.value = repository.fetchGames()
            _isLoading.value = false
        }
    }
}