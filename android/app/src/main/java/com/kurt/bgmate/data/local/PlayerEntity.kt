package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey
import com.kurt.bgmate.data.local.PlayerEntity.Companion.TABLE_NAME

@Entity(
    tableName = TABLE_NAME,
    indices = [Index("name", unique = true)]
)
data class PlayerEntity(
    @PrimaryKey(autoGenerate = true) val playerId: Long = 0,
    val name: String
) {
    companion object {
        const val COL_PLAYER_ID = "playerId"
        const val TABLE_NAME = "players"
    }
}