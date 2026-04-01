package com.kurt.bgmate.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface JudgeHistoryDao {

    @Insert
    suspend fun insert(entity: JudgeHistoryEntity)

    @Query("SELECT * FROM judge_history ORDER BY askedAt DESC")
    fun observeAll(): Flow<List<JudgeHistoryEntity>>

    @Query("DELETE FROM judge_history WHERE id = :id")
    suspend fun deleteById(id: Long)
}