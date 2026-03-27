package com.kurt.bgmate.data.local

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface BoardGameDao {

    @Query("SELECT * FROM board_games ORDER BY addedAt DESC")
    fun observeGames(): Flow<List<BoardGameEntity>>

    @Query("SELECT * FROM board_games WHERE id = :id")
    suspend fun getGameById(id: String): BoardGameEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertGame(game: BoardGameEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(games: List<BoardGameEntity>)

    @Delete
    suspend fun delete(game: BoardGameEntity)

    @Query("DELETE FROM board_games WHERE id = :id")
    suspend fun deleteGameById(id: String)

    @Query("UPDATE board_games SET name = :name WHERE id = :id")
    suspend fun updateGameName(id: String, name: String)
}