package com.kurt.bgmate.domain.repository

import kotlinx.coroutines.flow.Flow

interface GameRepository {
    fun getGames(): List<String>
    fun addGame(name: String)
    fun removeGame(name: String)
    fun updateGame(old: String, new: String)

    suspend fun fetchGames(): List<String>

    fun observeGames(): Flow<List<String>>
}

