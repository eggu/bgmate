package com.kurt.bgmate.data.repository

import android.util.Log
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

class GameRepositoryImpl @Inject constructor() : GameRepository {
    private val games = mutableListOf<BoardGame>()

    override fun getGames(): List<BoardGame> = games.toList()

    override fun addGame(name: String) {
        games.add(BoardGame(name))
    }

    override fun removeGame(name: String) {
        games.removeIf { it.name == name }
    }

    override fun updateGame(old: String, new: String) {
        val index = games.indexOfFirst { it.name == old }
        if (index != -1) {
            games[index] = BoardGame(new)
        }
    }

    override suspend fun fetchGames(): List<BoardGame> {
        delay(1000)
        if (Math.random() > 0.5) throw Exception("Failed to fetch games")
        return listOf(BoardGame("카탄"), BoardGame("아줄"), BoardGame("윙스팬"))
    }

    override fun observeGames(): Flow<List<BoardGame>> = flow {
        var count = 1
        while (true) {
            Log.d("Flow", "emit: count=$count")
            emit(List(count++) { BoardGame("Game $it") })
            delay(3000)
        }
    }
}

