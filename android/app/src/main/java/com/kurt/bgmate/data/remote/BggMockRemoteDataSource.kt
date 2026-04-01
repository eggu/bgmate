package com.kurt.bgmate.data.remote

import android.content.Context
import com.kurt.bgmate.domain.model.BoardGame
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class BggMockRemoteDataSource @Inject constructor(
    @ApplicationContext private val context: Context
) : BggRemoteDataSource {

    override suspend fun searchGames(query: String): List<BoardGame> = withContext(Dispatchers.IO) {
        runCatching {
            context.assets.open("bgg_sample_search.xml")
                .bufferedReader()
                .use { it.readText() }
        }.getOrDefault("")
            .let(BggXmlParser::parseSearchResult)
            .map { it.toDomain() }
    }
}
