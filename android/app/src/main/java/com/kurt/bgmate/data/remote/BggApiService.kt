package com.kurt.bgmate.data.remote

import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

interface BggApiService {
    @GET("xmlapi2/search")
    suspend fun searchGames(
        @Query("query") query: String,
        @Query("type") type: String = "boardgame",
    ): String

    @GET("xmlapi2/thing")
    suspend fun getGameDetail(
        @Query(value = "id", encoded = true) gameId: String,
        @Query("type") type: String = "boardgame"
    ): String
}