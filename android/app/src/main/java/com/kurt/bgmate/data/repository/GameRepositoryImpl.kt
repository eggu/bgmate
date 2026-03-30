package com.kurt.bgmate.data.repository

import com.kurt.bgmate.data.local.BoardGameDao
import com.kurt.bgmate.data.local.BoardGameEntity
import com.kurt.bgmate.data.local.toDomain
import com.kurt.bgmate.data.remote.BggRemoteDataSource
import com.kurt.bgmate.data.remote.BggXmlParser
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.repository.GameRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class GameRepositoryImpl @Inject constructor(
    private val dao: BoardGameDao,
    private val bggRemoteDataSource: BggRemoteDataSource
) :
    GameRepository {
    private val games = mutableListOf<BoardGame>()

    override fun getGames(): List<BoardGame> = games.toList()

    override suspend fun addGame(name: String) {
        // 임시 ID 생성 — BGG 승인 후 실제 bggId로 교체 예정
        val tempId = "local_${System.currentTimeMillis()}"
        dao.insertGame(BoardGameEntity(bggId = tempId, name = name))
    }

    override suspend fun removeGame(name: String) {
       val entity =  dao.observeGames().first().first() { it.name == name }
        dao.delete(entity)
    }

    override suspend fun updateGame(old: String, new: String) {
        val entity =  dao.observeGames().first().first() { it.name == old } ?: return
        dao.updateGameName(entity.bggId, new)
    }

    override suspend fun searchGames(query: String): List<BoardGame> {
        val xml = bggRemoteDataSource.searchGames(query)
        return BggXmlParser.parseSearchResult(xml).map { BoardGame(it.id, it.name) }
    }

    override suspend fun getGameById(id: String): BoardGame? {
        return dao.getGameById(id = id)?.toDomain()
    }

    override fun observeGames(): Flow<List<BoardGame>> = dao.observeGames().map { list -> list.map { it.toDomain() } }
}

