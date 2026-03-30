package com.kurt.bgmate.domain.model

data class BoardGame(
    val bggId: String, val name: String,
    val yearPublished: String? = null,
    val thumbnailUrl: String? = null,
)
