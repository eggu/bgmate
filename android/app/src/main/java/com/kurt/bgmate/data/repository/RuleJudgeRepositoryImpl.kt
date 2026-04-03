package com.kurt.bgmate.data.repository

import android.content.Context
import com.kurt.bgmate.data.local.JudgeHistoryDao
import com.kurt.bgmate.data.local.JudgeHistoryEntity
import com.kurt.bgmate.data.local.toDomain
import com.kurt.bgmate.data.remote.llm.LlmClient
import com.kurt.bgmate.data.remote.llm.LlmMessage
import com.kurt.bgmate.data.remote.llm.LlmRequest
import com.kurt.bgmate.domain.model.JudgeResult
import com.kurt.bgmate.domain.repository.RuleJudgeRepository
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class RuleJudgeRepositoryImpl @Inject constructor(
    private val llmClient: LlmClient,
    val judgeHistoryDao: JudgeHistoryDao,
    @ApplicationContext private val context: Context
) : RuleJudgeRepository {
    private val systemPrompt: String by lazy {
        context.assets.open("rule_judge_prompt.txt").bufferedReader().use { it.readText() }
    }

    override fun judge(
        gameName: String,
        dispute: String
    ): Flow<String> {
        val userMessage = "게임 이름: $gameName\n\n[분쟁 상황]\n$dispute"

        val request = LlmRequest(
            messages = listOf(LlmMessage(role = "user", content = userMessage)),
            systemPrompt = systemPrompt,
            maxTokens = 4096
        )

        return llmClient.stream(request)
    }

    override suspend fun saveHistory(
        gameName: String,
        dispute: String,
        answer: String
    ) {
        judgeHistoryDao.insert(
            JudgeHistoryEntity(
                gameName = gameName,
                dispute = dispute,
                answer = answer
            )
        )
    }

    override fun observeHistory(): Flow<List<JudgeResult>> =
        judgeHistoryDao.observeAll().map { list -> list.map { it.toDomain() } }
}
