package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kurt.bgmate.domain.model.BoardGame

@Entity(tableName = "board_games")
data class BoardGameEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val yearPublished: String? = null,
    val thumbnailUrl: String? = null,
    val addedAt: Long = System.currentTimeMillis()
) {
}

fun BoardGameEntity.toDomain() = BoardGame(
    id = id,
    name = name,
    yearPublished = yearPublished,
    thumbnailUrl = thumbnailUrl,
)

fun BoardGame.toEntity() = BoardGameEntity(
    id = id,
    name = name,
    yearPublished = yearPublished,
    thumbnailUrl = thumbnailUrl,
)