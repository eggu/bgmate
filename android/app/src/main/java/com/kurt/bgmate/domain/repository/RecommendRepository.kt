package com.kurt.bgmate.domain.repository

import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.RecommendCondition
import com.kurt.bgmate.domain.model.RecommendResult

interface RecommendRepository {
    suspend fun recommend(condition: RecommendCondition, includeNew: Boolean, ownedGames: List<BoardGame>): List<RecommendResult>
}