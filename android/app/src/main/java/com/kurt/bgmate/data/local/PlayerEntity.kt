package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import com.kurt.bgmate.data.local.PlayerEntity.Companion.TABLE_NAME
import com.kurt.bgmate.data.local.SessionEntity.Companion.COL_SESSION_ID

@Entity(
    tableName = TABLE_NAME,
    foreignKeys = [ForeignKey(
        entity = SessionEntity::class,
        parentColumns = [COL_SESSION_ID],
        childColumns = [COL_SESSION_ID],
        onDelete = ForeignKey.CASCADE
    )],
    indices = [Index(COL_SESSION_ID)]
)
data class PlayerEntity(
    @PrimaryKey(autoGenerate = true) val playerId: Long = 0,
    val sessionId: Long,
    val name: String
) {
    companion object {
        const val COL_PLAYER_ID = "playerId"
        const val TABLE_NAME = "players"
    }
}