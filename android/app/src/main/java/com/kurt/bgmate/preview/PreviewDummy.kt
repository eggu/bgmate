package com.kurt.bgmate.preview

import com.kurt.bgmate.GameListViewModel
import com.kurt.bgmate.GameRepositoryImpl

/**
 * Android Studio Preview에서 Hilt가 제대로 주입되지 않는 경우를 대비한 공통 더미 헬퍼입니다.
 */
object PreviewDummy {
    private val previewGames = listOf("카탄", "아줄", "스플렌더")

    fun createGameListViewModel(): GameListViewModel {
        val repository = GameRepositoryImpl()
        val viewModel = GameListViewModel(repository = repository)
        // ViewModel의 StateFlow은 add/remove/update에서 갱신되므로 미리 seed를 넣습니다.
        previewGames.forEach { viewModel.addGame(it) }
        return viewModel
    }
}

