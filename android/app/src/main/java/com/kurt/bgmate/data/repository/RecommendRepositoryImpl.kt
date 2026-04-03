package com.kurt.bgmate.data.repository

import android.content.Context
import android.util.Log
import com.kurt.bgmate.data.remote.llm.LlmClient
import com.kurt.bgmate.data.remote.llm.LlmMessage
import com.kurt.bgmate.data.remote.llm.LlmRequest
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.RecommendCondition
import com.kurt.bgmate.domain.model.RecommendResult
import com.kurt.bgmate.domain.repository.RecommendRepository
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okio.IOException
import org.json.JSONArray
import org.json.JSONObject
import javax.inject.Inject

class RecommendRepositoryImpl @Inject constructor(
    private val llmClient: LlmClient,
    @ApplicationContext private val context: Context
) : RecommendRepository {
    companion object {
        private const val TAG = "RecommendRepositoryImpl"
    }

    override suspend fun recommend(
        condition: RecommendCondition,
        includeNew: Boolean,
        ownedGames: List<BoardGame>
    ): List<RecommendResult> = withContext(Dispatchers.IO) {
        try {
            val prompt = buildPrompt(condition, ownedGames, includeNew)
            val request = LlmRequest(
                messages = listOf(LlmMessage(role = "user", content = prompt)),
                maxTokens = 8192
            )
            val response = llmClient.complete(request)
            parseRecommendResponse(response.text)
        } catch (e: Exception) {
            Log.e(TAG, "recommend: $e", e)
            throw IOException("추천을 가져오지 못했습니다.")
        }
    }

    private fun buildPrompt(
        condition: RecommendCondition,
        games: List<BoardGame>,
        includeNew: Boolean
    ): String {
        val fileName = "recommend_prompt_${if (includeNew) "all" else "owned"}.txt"

        val template = context.assets.open(fileName)
            .bufferedReader().readText()

        val moodText = condition.moods.joinToString(", ") { it.label }
        val gameListText = if (games.isEmpty()) "없음"
        else games.take(30).joinToString("\n") { "- ${it.name}" }

        return template
            .replace("{playerCount}", condition.playerCount.toString())
            .replace("{playTime}", condition.playTimeMinutes.label)
            .replace("{moods}", moodText)
            .replace("{gameList}", gameListText)
    }

    private fun parseRecommendResponse(raw: String): List<RecommendResult> {
        return try {
            val start = raw.indexOf('[')
            val end = raw.lastIndexOf(']') + 1
            if (start == -1 || end == 0) return emptyList()

            val array = JSONArray(raw.substring(start, end))
            (0 until array.length()).map { i ->
                val obj = array.getJSONObject(i)
                RecommendResult(
                    name = obj.getString("name"),
                    reason = obj.getString("reason"),
                    isOwned = obj.optBoolean("isOwned", false),
                    bggScore = obj.optDouble("bggScore", 0.0).toFloat(),
                    difficulty = obj.optString("difficulty", "")
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "parseRecommendResponse: $e", e)
            emptyList()
        }
    }
}
