package com.kurt.bgmate.data.local

import androidx.room.Embedded
import androidx.room.Relation
import com.kurt.bgmate.data.local.PlayerEntity.Companion.COL_PLAYER_ID
import com.kurt.bgmate.data.local.SessionEntity.Companion.COL_SESSION_ID


data class PlayerWithScores(
    @Embedded val player: PlayerEntity,
    @Relation(
        parentColumn = COL_PLAYER_ID,
        entityColumn = COL_PLAYER_ID,
        entity = ScoreEntryEntity::class
    )
    val scores: List<ScoreEntryEntity>
)

data class SessionWithDetails(
    @Embedded val session: SessionEntity,
    @Relation(
        parentColumn = COL_SESSION_ID,
        entityColumn = COL_SESSION_ID,
        entity = PlayerEntity::class
    )
    val players: List<PlayerWithScores>
)
