package com.kurt.bgmate.data.remote

import com.kurt.bgmate.domain.model.BoardGame

interface BggRemoteDataSource {
    suspend fun searchGames(query: String): List<BoardGame>
    suspend fun fetchThumbnails(ids: List<String>): Map<String, String>
}