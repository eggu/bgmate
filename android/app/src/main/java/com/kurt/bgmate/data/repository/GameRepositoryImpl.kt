package com.kurt.bgmate.data.repository

import com.kurt.bgmate.data.remote.BggRemoteDataSource
import com.kurt.bgmate.data.remote.BggXmlParser
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import javax.inject.Inject

class GameRepositoryImpl @Inject constructor(private val bggRemoteDataSource: BggRemoteDataSource) :
    GameRepository {
    private val games = mutableListOf<BoardGame>()

    override fun getGames(): List<BoardGame> = games.toList()

    override fun addGame(game: BoardGame) {
        games.add(game)
    }

    override fun removeGame(game: BoardGame) {
        games.remove(game)
    }

    override fun updateGame(game: BoardGame) {
        val index = games.indexOfFirst { it.id == game.id }
        if (index != -1) {
            games[index] = game
        }
    }

    override suspend fun fetchGames(): List<BoardGame> {
        games.addAll(listOf(BoardGame("1", "카탄"), BoardGame("2", "아줄"), BoardGame("3", "윙스팬")))
        return games
    }

    override suspend fun searchGames(query: String): List<BoardGame> {
        val xml = bggRemoteDataSource.searchGames(query)
        return BggXmlParser.parseSearchResult(xml).map { BoardGame(it.id, it.name) }
    }

//    override fun observeGames(): Flow<List<BoardGame>> = flow {
//        var count = 1
//        while (true) {
//            Log.d("Flow", "emit: count=$count")
//            emit(List(count++) { BoardGame("Game $it",) })
//            delay(3000)
//        }
//    }
}

