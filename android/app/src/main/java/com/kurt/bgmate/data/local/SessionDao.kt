package com.kurt.bgmate.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Transaction
import kotlinx.coroutines.flow.Flow

@Dao
interface SessionDao {

    @Insert
    suspend fun insertSession(session: SessionEntity): Long

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insertPlayerIfNotExists(player: PlayerEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertScore(scoreEntry: ScoreEntryEntity)

    @Transaction
    @Query("SELECT * FROM sessions ORDER BY playedAt DESC")
    fun observeAllSessions(): Flow<List<SessionWithDetails>>

    @Transaction
    @Query("SELECT * FROM sessions WHERE sessionId = :sessionId")
    suspend fun getSessionWithDetails(sessionId: Long): SessionWithDetails?

    @Query("SELECT * FROM players WHERE name = :name")
    suspend fun getPlayerByName(name: String): PlayerEntity


    @Query("DELETE FROM sessions WHERE sessionId = :sessionId")
    suspend fun deleteSession(sessionId: Long)

    @Transaction
    suspend fun insertSessionWithPlayers(
        session: SessionEntity,
        players: List<PlayerEntity>,
        scores: List<ScoreEntryEntity>
    ) {
        val sessionId = insertSession(session)
        players.forEachIndexed { index, playerEntity ->
            insertPlayerIfNotExists(playerEntity)
            val playerId = getPlayerByName(playerEntity.name).playerId
            insertScore(scores[index].copy(playerId = playerId, sessionId = sessionId))
        }
    }
}