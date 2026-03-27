package com.kurt.bgmate.domain.model

data class BoardGame(val id: String, val name: String,
    val yearPublished: String? = null,
    val thumbnailUrl: String? = null,
)
