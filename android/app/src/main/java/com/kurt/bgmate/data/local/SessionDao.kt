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

    @Insert
    suspend fun insertPlayer(player: PlayerEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertScoreEntry(scoreEntry: ScoreEntryEntity)

    @Transaction
    @Query("SELECT * FROM sessions ORDER BY playedAt DESC")
    fun observeAllSessions(): Flow<List<SessionWithDetails>>

    @Transaction
    @Query("SELECT * FROM sessions WHERE sessionId = :sessionId")
    suspend fun getSessionWithDetails(sessionId: Long): SessionWithDetails?

    @Query("DELETE FROM sessions WHERE sessionId = :sessionId")
    suspend fun deleteSession(sessionId: Long)
}