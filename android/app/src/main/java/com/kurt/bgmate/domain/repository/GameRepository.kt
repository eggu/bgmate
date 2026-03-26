package com.kurt.bgmate.domain.repository

import com.kurt.bgmate.domain.model.BoardGame
import kotlinx.coroutines.flow.Flow

interface GameRepository {
    fun getGames(): List<BoardGame>
    fun addGame(name: String)
    fun removeGame(name: String)
    fun updateGame(old: String, new: String)

    suspend fun fetchGames(): List<BoardGame>

    fun observeGames(): Flow<List<BoardGame>>
}

