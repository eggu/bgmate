package com.kurt.bgmate

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class GameListViewModel : ViewModel() {

    private val _items = MutableStateFlow(listOf("윙스팬", "카탄", "백로성", "스플렌더", "버건디의 성", "사이드"))
    val items: StateFlow<List<String>> = _items.asStateFlow()

    fun addGame(name: String) {
        val trimmedText = name.trim()
        if (trimmedText.isBlank()) return
        _items.value += trimmedText
    }

    fun removeGame(name: String) {
        _items.value -= name
    }

    fun updateGame(old: String, new: String) {
        val trimmed = new.trim()
        if (trimmed.isBlank()) return
        _items.value = _items.value.map {
            if (it == old) trimmed else it
        }
    }
}