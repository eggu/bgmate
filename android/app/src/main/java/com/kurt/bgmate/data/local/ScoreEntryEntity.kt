package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import com.kurt.bgmate.data.local.PlayerEntity.Companion.COL_PLAYER_ID
import com.kurt.bgmate.data.local.ScoreEntryEntity.Companion.TABLE_NAME
import com.kurt.bgmate.data.local.SessionEntity.Companion.COL_SESSION_ID

@Entity(
    tableName = TABLE_NAME,
    foreignKeys = [
        ForeignKey(
            entity = SessionEntity::class,
            parentColumns = [COL_SESSION_ID],
            childColumns = [COL_SESSION_ID],
        ),
        ForeignKey(
            entity = PlayerEntity::class,
            parentColumns = [COL_PLAYER_ID],
            childColumns = [COL_PLAYER_ID]
        )],
    indices = [Index(COL_SESSION_ID), Index(COL_PLAYER_ID)]
)
data class ScoreEntryEntity(
    @PrimaryKey(autoGenerate = true) val entryId: Long = 0,
    val sessionId: Long,
    val playerId: Long,
    val score: Int
) {
    companion object {
        const val TABLE_NAME = "score_entries"
        const val COL_ENTRY_ID = "entryId"
    }
}