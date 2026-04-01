package com.kurt.bgmate.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kurt.bgmate.domain.model.JudgeResult

@Entity(tableName = "judge_history")
data class JudgeHistoryEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val gameName: String,
    val dispute: String,
    val answer: String,
    val askedAt: Long = System.currentTimeMillis()
) {
}

fun JudgeHistoryEntity.toDomain() = JudgeResult(
    id = id,
    gameName = gameName,
    dispute = dispute,
    answer = answer,
    askedAt = askedAt
)

fun JudgeResult.toEntity() = JudgeHistoryEntity(
    id = id,
    gameName = gameName,
    dispute = dispute,
    answer = answer,
    askedAt = askedAt
)