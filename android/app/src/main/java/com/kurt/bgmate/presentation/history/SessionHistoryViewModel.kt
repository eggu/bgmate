package com.kurt.bgmate.presentation.history

import androidx.lifecycle.viewModelScope
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.presentation.common.BaseViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn
import javax.inject.Inject

@HiltViewModel
class SessionHistoryViewModel @Inject constructor(private val gameRepository: GameRepository) :
    BaseViewModel() {
    val sessions = gameRepository.observeSessionHistory()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )


}