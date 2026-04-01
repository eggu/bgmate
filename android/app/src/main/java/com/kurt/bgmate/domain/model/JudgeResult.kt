package com.kurt.bgmate.domain.model

data class JudgeResult(
    val gameName: String,
    val dispute: String,
    val answer: String,
    val askedAt: Long = System.currentTimeMillis()
) {
}