package com.kurt.bgmate.domain.model

data class RecommendResult(
    val name: String,
    val reason: String,
    val isOwned: Boolean,
    val bggScore: Float? = null,
    val difficulty: String? = null
)
