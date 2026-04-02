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

    override suspend fun fetchThumbnails(ids: List<String>): Map<String, String> {
        if (ids.isEmpty()) return emptyMap()
        return try {
            val xmlString = bggApiService.getGameDetail(ids.joinToString(","))
            BggXmlParser.parseThingThumbnails(xmlString)
        } catch (e: Exception) {
            emptyMap()
        }
    }
}