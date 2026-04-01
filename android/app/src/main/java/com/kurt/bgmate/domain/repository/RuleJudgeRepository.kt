package com.kurt.bgmate.domain.repository

import com.kurt.bgmate.domain.model.JudgeResult
import kotlinx.coroutines.flow.Flow

interface RuleJudgeRepository {
    fun judge(gameName: String, dispute: String): Flow<String>
    suspend fun saveHistory(gameName: String, dispute: String, answer: String)
    fun observeHistory(): Flow<List<JudgeResult>>
}