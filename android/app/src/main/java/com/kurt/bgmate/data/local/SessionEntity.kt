package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import com.kurt.bgmate.data.local.BoardGameEntity.Companion.COL_BGG_ID
import com.kurt.bgmate.data.local.SessionEntity.Companion.TABLE_NAME


@Entity(
    tableName = TABLE_NAME,
    foreignKeys = [ForeignKey(
        entity = BoardGameEntity::class, parentColumns = [COL_BGG_ID], childColumns = [COL_BGG_ID],
        onDelete = ForeignKey.CASCADE
    )],
    indices = [Index(COL_BGG_ID)]
)
data class SessionEntity(
    @PrimaryKey(autoGenerate = true) val sessionId: Long,
    val bggId: String,
    val playedAt: Long = System.currentTimeMillis()
) {
    companion object {
        const val COL_SESSION_ID = "sessionId"
        const val TABLE_NAME = "sessions"
    }
}
