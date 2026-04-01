package com.kurt.bgmate.data.repository

import android.content.Context
import com.kurt.bgmate.BuildConfig
import com.kurt.bgmate.domain.repository.RuleJudgeRepository
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import okhttp3.Dispatcher
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okio.IOException
import org.json.JSONArray
import org.json.JSONObject
import javax.inject.Inject

class RuleJudgeRepositoryImpl @Inject constructor(
    private val okHttpClient: OkHttpClient,
    @ApplicationContext private val context: Context
) : RuleJudgeRepository {
    companion object {
        private const val API_URL = "https://api.anthropic.com/v1/messages"
        private const val MODEL = "claude-sonnet-4-5"  // claude-sonnet-4-6으로 업데이트 권장
    }

    private val systemPrompt: String by lazy {
        context.assets.open("rule_judge_prompt.txt").bufferedReader().use { it.readText() }
    }

    override fun judge(
        gameName: String,
        dispute: String
    ): Flow<String> = flow {
        val userMessage = "게임 이름: $gameName\n\n[분쟁 상황]\n$dispute"

        val requestBody = JSONObject().apply {
            put("model", MODEL)
            put("max_tokens", 1024)
            put("stream", true)
            put("system", systemPrompt)
            put("messages", JSONArray().apply {
                put(JSONObject().apply {
                    put("role", "user")
                    put("content", userMessage)
                })
            })
        }.toString()

        val request = Request.Builder()
            .url(API_URL)
            .addHeader("x-api-key", BuildConfig.CLAUDE_API_KEY)
            .addHeader("anthropic-version", "2023-06-01")
            .addHeader("content-type", "application/json")
            .post(requestBody.toRequestBody("application/json".toMediaType()))
            .build()

        val response = okHttpClient.newCall(request).execute()

        if (!response.isSuccessful) {
            throw IOException("API 오류 ${response.code}")
        }

        response.body.source().use { source ->
            while (!source.exhausted()) {
                val line = source.readUtf8Line() ?: break

                if (!line.startsWith("data: ")) continue

                val data = line.removePrefix(("data: "))

                val chunk = runCatching {
                    val json = JSONObject(data)
                    val type = json.optString("type")
                    if (type == "content_block_delta") {
                        json.getJSONObject("delta").optString("text", "")
                    } else ""
                }.getOrDefault("")

                if (chunk.isNotEmpty()) emit(chunk)
            }
        }
    }.flowOn(Dispatchers.IO)
}