package com.kurt.bgmate.domain.repository

import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.ScoreSession
import kotlinx.coroutines.flow.Flow

interface GameRepository {
    fun getGames(): List<BoardGame>
    suspend fun addGame(name: String)
    suspend fun addGame(game: BoardGame)
    suspend fun removeGame(name: String)
    suspend fun updateGame(old: String, new: String)

    suspend fun searchGames(query: String): List<BoardGame>

    suspend fun getGameById(id: String): BoardGame?

    fun observeGames(): Flow<List<BoardGame>>

    fun observeSessionHistory(): Flow<List<ScoreSession>>
    suspend fun getSessionById(sessionId: Long): ScoreSession?
}

