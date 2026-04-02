package com.kurt.bgmate.fake

import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.ScoreSession
import com.kurt.bgmate.domain.repository.GameRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flowOf

class FakeGameRepository : GameRepository {

    private val _gamesFlow = MutableStateFlow<List<BoardGame>>(emptyList())

    val addedByNameCalls = mutableListOf<String>()
    val addedByGameCalls = mutableListOf<BoardGame>()
    val removedCalls = mutableListOf<String>()
    val searchCalls = mutableListOf<String>()

    var searchResult: List<BoardGame> = emptyList()
    var searchException: Exception? = null

    fun setGames(games: List<BoardGame>) {
        _gamesFlow.value = games
    }

    override suspend fun addGame(name: String) {
        addedByNameCalls.add(name)
        _gamesFlow.value = _gamesFlow.value + BoardGame(bggId = "local_$name", name = name)
    }

    override suspend fun addGame(game: BoardGame) {
        addedByGameCalls.add(game)
        _gamesFlow.value = _gamesFlow.value + game
    }

    override suspend fun removeGame(name: String) {
        removedCalls.add(name)
        _gamesFlow.value = _gamesFlow.value.filter { it.name != name }
    }

    override suspend fun updateGame(old: String, new: String) {
        _gamesFlow.value = _gamesFlow.value.map {
            if (it.name == old) it.copy(name = new) else it
        }
    }

    override suspend fun searchGames(query: String): List<BoardGame> {
        searchCalls.add(query)
        searchException?.let { throw it }
        return searchResult
    }

    override suspend fun getGameById(id: String): BoardGame? =
        _gamesFlow.value.find { it.bggId == id }

    override fun observeGames(): Flow<List<BoardGame>> = _gamesFlow

    override fun observeSessionHistory(): Flow<List<ScoreSession>> = flowOf(emptyList())

    override suspend fun getSessionById(sessionId: Long): ScoreSession? = null

    override suspend fun fetchThumbnails(ids: List<String>): Map<String, String> = emptyMap()
}
