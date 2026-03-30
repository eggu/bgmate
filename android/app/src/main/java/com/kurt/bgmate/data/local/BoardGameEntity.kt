package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kurt.bgmate.data.local.BoardGameEntity.Companion.TABLE_NAME
import com.kurt.bgmate.domain.model.BoardGame

@Entity(tableName = TABLE_NAME)
data class BoardGameEntity(
    @PrimaryKey
    val bggId: String,
    val name: String,
    val yearPublished: String? = null,
    val thumbnailUrl: String? = null,
    val addedAt: Long = System.currentTimeMillis()
) {
    companion object {
        const val COL_BGG_ID = "bggId"
        const val TABLE_NAME = "board_games"
    }
}

fun BoardGameEntity.toDomain() = BoardGame(
    id = bggId,
    name = name,
    yearPublished = yearPublished,
    thumbnailUrl = thumbnailUrl,
)

fun BoardGame.toEntity() = BoardGameEntity(
    bggId = id,
    name = name,
    yearPublished = yearPublished,
    thumbnailUrl = thumbnailUrl,
)