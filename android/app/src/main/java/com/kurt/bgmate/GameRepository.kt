package com.kurt.bgmate

import android.util.Log
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

interface GameRepository {
    fun getGames(): List<String>
    fun addGame(name: String)
    fun removeGame(name: String)
    fun updateGame(old: String, new: String)

    suspend fun fetchGames(): List<String>

    fun observeGames(): Flow<List<String>>
}

class GameRepositoryImpl @Inject constructor() : GameRepository {
    private val games = mutableListOf<String>()

    override fun getGames(): List<String> = games.toList()
    override fun addGame(name: String) {
        games.add(name)
    }

    override fun removeGame(name: String) {
        games.remove(name)
    }

    override fun updateGame(old: String, new: String) {
        val index = games.indexOf(old)
        if (index != -1) {
            games[index] = new
        }
    }

    override suspend fun fetchGames(): List<String> {
        delay(1000)
        return listOf("카탄", "아줄", "윙스팬")
    }

    override fun observeGames(): Flow<List<String>> = flow {
        var count = 1
        while (true) {
            Log.d("Flow", "emit: count=$count") // ← 백그라운드에서 멈추는지 확인
            emit(List(count++) { "Game $it" })
            delay(3000)
        }
    }
}