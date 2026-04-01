package com.kurt.bgmate.fake

import com.kurt.bgmate.domain.model.JudgeResult
import com.kurt.bgmate.domain.repository.RuleJudgeRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOf

class FakeRuleJudgeRepository : RuleJudgeRepository {

    var judgeChunks: List<String> = listOf("판정 결과입니다.")
    var judgeException: Throwable? = null

    val savedHistories = mutableListOf<Triple<String, String, String>>()
    private val _historyFlow = MutableStateFlow<List<JudgeResult>>(emptyList())

    override fun judge(gameName: String, dispute: String): Flow<String> = flow {
        judgeException?.let { throw it }
        judgeChunks.forEach { emit(it) }
    }

    override suspend fun saveHistory(gameName: String, dispute: String, answer: String) {
        savedHistories.add(Triple(gameName, dispute, answer))
        _historyFlow.value = _historyFlow.value + JudgeResult(
            gameName = gameName,
            dispute = dispute,
            answer = answer
        )
    }

    override fun observeHistory(): Flow<List<JudgeResult>> = _historyFlow
}
