package com.kurt.bgmate.presentation.common

sealed interface UiEvent {
    data class ShowMessage(val message: String): UiEvent
}