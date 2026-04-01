package com.kurt.bgmate.domain.repository

import kotlinx.coroutines.flow.Flow

interface RuleJudgeRepository {
    fun judge(gameName: String, dispute: String): Flow<String>
}