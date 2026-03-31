package com.kurt.bgmate.data.local

import androidx.room.Embedded
import androidx.room.Relation
import com.kurt.bgmate.data.local.PlayerEntity.Companion.COL_PLAYER_ID
import com.kurt.bgmate.data.local.SessionEntity.Companion.COL_SESSION_ID
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.PlayerScore
import com.kurt.bgmate.domain.model.ScoreSession


data class SessionWithDetails(
    @Embedded val session: SessionEntity,
    @Relation(
        parentColumn = COL_SESSION_ID,
        entityColumn = COL_SESSION_ID,
        entity = ScoreEntryEntity::class
    )
    val scores: List<ScoreEntryWithPlayer>
)

data class ScoreEntryWithPlayer(
    @Embedded
    val score: ScoreEntryEntity,

    @Relation(
        parentColumn = COL_PLAYER_ID,
        entityColumn = COL_PLAYER_ID
    )
    val player: PlayerEntity
)

fun SessionWithDetails.toDomain(): ScoreSession = ScoreSession(
    sessionId = session.sessionId,
    game = BoardGame(bggId = session.bggId, name = session.gameName),
    players = scores
        .map { entry ->
            PlayerScore(
                playerId = entry.player.playerId,
                name = entry.player.name,
                totalScore = entry.score.score
            )
        }
        .sortedByDescending { it.totalScore },
    playedAt = session.playedAt     // 추가
)