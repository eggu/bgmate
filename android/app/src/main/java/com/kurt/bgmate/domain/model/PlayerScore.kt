package com.kurt.bgmate.domain.model

data class PlayerScore(val playerId: Long,
    val name: String,
    val totalScore: Int = 0) {
}