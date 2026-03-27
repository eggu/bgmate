package com.kurt.bgmate.domain.repository

import com.kurt.bgmate.domain.model.BoardGame
import kotlinx.coroutines.flow.Flow

interface GameRepository {
    fun getGames(): List<BoardGame>
    suspend fun addGame(name: String)
    suspend fun removeGame(name: String)
    suspend fun updateGame(old: String, new: String)

    suspend fun searchGames(query: String): List<BoardGame>

    fun observeGames(): Flow<List<BoardGame>>
}

