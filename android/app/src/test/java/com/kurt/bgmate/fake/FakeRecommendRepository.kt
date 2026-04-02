package com.kurt.bgmate.fake

import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.RecommendCondition
import com.kurt.bgmate.domain.model.RecommendResult
import com.kurt.bgmate.domain.repository.RecommendRepository

class FakeRecommendRepository : RecommendRepository {

    data class RecommendCall(
        val condition: RecommendCondition,
        val includeNew: Boolean,
        val ownedGames: List<BoardGame>,
    )

    val recommendCalls = mutableListOf<RecommendCall>()

    var recommendResult: List<RecommendResult> = emptyList()
    var recommendException: Exception? = null

    override suspend fun recommend(
        condition: RecommendCondition,
        includeNew: Boolean,
        ownedGames: List<BoardGame>,
    ): List<RecommendResult> {
        recommendCalls += RecommendCall(
            condition = condition,
            includeNew = includeNew,
            ownedGames = ownedGames
        )
        recommendException?.let { throw it }
        return recommendResult
    }
}
