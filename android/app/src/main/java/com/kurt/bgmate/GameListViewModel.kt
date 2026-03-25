package com.kurt.bgmate

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class GameListViewModel : ViewModel() {

    private val _items = MutableStateFlow(listOf(""))
    val items: StateFlow<List<String>> = _items.asStateFlow()

    fun addItem(name: String) {
        val trimmedText = name.trim()
        if (trimmedText.isBlank()) return
        _items.value += trimmedText
    }

    fun removeItem(name: String) {
        _items.value -= name
    }
}