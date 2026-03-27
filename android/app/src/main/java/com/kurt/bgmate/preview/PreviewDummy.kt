package com.kurt.bgmate.preview

import android.content.Context
import com.kurt.bgmate.data.remote.BggApiService
import com.kurt.bgmate.data.remote.BggRemoteDataSource
import com.kurt.bgmate.data.repository.GameRepositoryImpl
import com.kurt.bgmate.presentation.GameListViewModel

/**
 * Android Studio Preview에서 Hilt가 제대로 주입되지 않는 경우를 대비한 공통 더미 헬퍼입니다.
 */
object PreviewDummy {
    private val previewGames = listOf("카탄", "아줄", "스플렌더")

    fun createGameListViewModel(context: Context): GameListViewModel {
        val repository = GameRepositoryImpl(BggRemoteDataSource(context))
        val apiService = object : BggApiService {
            override suspend fun searchGames(
                query: String,
                type: String
            ): String = ""

            override suspend fun getGameDetail(gameId: String): String = ""
        }
        val viewModel = GameListViewModel(repository = repository, apiService = apiService)
        // ViewModel의 StateFlow은 add/remove/update에서 갱신되므로 미리 seed를 넣습니다.
        previewGames.forEach { viewModel.addGame(it) }
        return viewModel
    }
}
