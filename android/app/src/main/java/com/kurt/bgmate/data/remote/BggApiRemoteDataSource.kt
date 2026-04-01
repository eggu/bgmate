package com.kurt.bgmate.data.remote

import com.kurt.bgmate.domain.model.BoardGame
import javax.inject.Inject

class BggApiRemoteDataSource @Inject constructor(
    private val bggApiService: BggApiService
) : BggRemoteDataSource {

    override suspend fun searchGames(query: String): List<BoardGame> {
        return try {
            val xmlString = bggApiService.searchGames(query)
            BggXmlParser.parseSearchResult(xmlString).map { it.toDomain() }
        } catch (e: Exception) {
            emptyList()
        }
    }
}