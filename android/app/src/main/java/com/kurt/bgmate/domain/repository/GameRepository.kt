package com.kurt.bgmate.domain.repository

import com.kurt.bgmate.domain.model.BoardGame

interface GameRepository {
    fun getGames(): List<BoardGame>
    fun addGame(game: BoardGame)
    fun removeGame(game: BoardGame)
    fun updateGame(game: BoardGame)

    suspend fun fetchGames(): List<BoardGame>

    suspend fun searchGames(query: String): List<BoardGame>

//    fun observeGames(): Flow<List<BoardGame>>
}

