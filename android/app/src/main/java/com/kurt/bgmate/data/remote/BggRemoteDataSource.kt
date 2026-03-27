package com.kurt.bgmate.data.remote

import android.content.Context
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import javax.inject.Inject

class BggRemoteDataSource @Inject constructor(@ApplicationContext private val context: Context) {

    suspend fun searchGames(query: String): String = withContext(Dispatchers.IO) {
        context.assets.open("bgg_sample_search.xml")
            .bufferedReader()
            .use { it.readText() }
    }

//    🔜 BGG 승인 후: 아래 코드로 교체
//    suspend fun searchGames(query: String): String =
//        apiService.searchGames(query)
}