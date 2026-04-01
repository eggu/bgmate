package com.kurt.bgmate.data.repository

import com.kurt.bgmate.data.local.BoardGameDao
import com.kurt.bgmate.data.local.BoardGameEntity
import com.kurt.bgmate.data.local.SessionDao
import com.kurt.bgmate.data.local.toDomain
import com.kurt.bgmate.data.local.toEntity
import com.kurt.bgmate.data.remote.BggRemoteDataSource
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.ScoreSession
import com.kurt.bgmate.domain.repository.GameRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class GameRepositoryImpl @Inject constructor(
    private val gameDao: BoardGameDao,
    val sessionDao: SessionDao,
    private val bggRemoteDataSource: BggRemoteDataSource
) :
    GameRepository {
    private val games = mutableListOf<BoardGame>()

    override fun getGames(): List<BoardGame> = games.toList()

    override suspend fun addGame(name: String) {
        // 임시 ID 생성 — BGG 승인 후 실제 bggId로 교체 예정
        val tempId = "local_${System.currentTimeMillis()}"
        gameDao.insertGame(BoardGameEntity(bggId = tempId, name = name))
    }

    override suspend fun addGame(game: BoardGame) {
        gameDao.insertGame(game.toEntity())
    }

    override suspend fun removeGame(name: String) {
       val entity =  gameDao.observeGames().first().first() { it.name == name }
        gameDao.delete(entity)
    }

    override suspend fun updateGame(old: String, new: String) {
        val entity =  gameDao.observeGames().first().first() { it.name == old } ?: return
        gameDao.updateGameName(entity.bggId, new)
    }

    override suspend fun searchGames(query: String): List<BoardGame> {
        return bggRemoteDataSource.searchGames(query)
    }

    override suspend fun getGameById(id: String): BoardGame? {
        return gameDao.getGameById(id = id)?.toDomain()
    }

    override fun observeGames(): Flow<List<BoardGame>> = gameDao.observeGames().map { list -> list.map { it.toDomain() } }

    override fun observeSessionHistory(): Flow<List<ScoreSession>> =
        sessionDao.observeAllSessions().map { list -> list.map { it.toDomain() } }

    override suspend fun getSessionById(sessionId: Long): ScoreSession? =
        sessionDao.getSessionWithDetails(sessionId)?.toDomain()
}
