package com.kurt.bgmate.fake

import com.kurt.bgmate.data.local.PlayerEntity
import com.kurt.bgmate.data.local.ScoreEntryEntity
import com.kurt.bgmate.data.local.SessionDao
import com.kurt.bgmate.data.local.SessionEntity
import com.kurt.bgmate.data.local.SessionWithDetails
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOf

class FakeSessionDao : SessionDao {

    var insertCalled = false
    var lastInsertedSession: SessionEntity? = null
    var lastInsertedPlayers: List<PlayerEntity> = emptyList()
    var lastInsertedScores: List<ScoreEntryEntity> = emptyList()

    override suspend fun insertSession(session: SessionEntity): Long {
        lastInsertedSession = session
        return 1L
    }

    override suspend fun insertPlayerIfNotExists(player: PlayerEntity) {
        // no-op
    }

    override suspend fun insertScore(scoreEntry: ScoreEntryEntity) {
        // no-op
    }

    override fun observeAllSessions(): Flow<List<SessionWithDetails>> = flowOf(emptyList())

    override suspend fun getSessionWithDetails(sessionId: Long): SessionWithDetails? = null

    override suspend fun getPlayerByName(name: String): PlayerEntity =
        PlayerEntity(playerId = 1L, name = name)

    override suspend fun deleteSession(sessionId: Long) {
        // no-op
    }

    override suspend fun insertSessionWithPlayers(
        session: SessionEntity,
        players: List<PlayerEntity>,
        scores: List<ScoreEntryEntity>
    ) {
        insertCalled = true
        lastInsertedSession = session
        lastInsertedPlayers = players
        lastInsertedScores = scores
    }
}
