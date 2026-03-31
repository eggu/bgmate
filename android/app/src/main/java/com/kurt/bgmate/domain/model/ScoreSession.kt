package com.kurt.bgmate.domain.model

data class ScoreSession(
    val sessionId: Long = 0,
    val game: BoardGame,
    val players: List<PlayerScore> = emptyList(),
    val playedAt: Long
) {
}