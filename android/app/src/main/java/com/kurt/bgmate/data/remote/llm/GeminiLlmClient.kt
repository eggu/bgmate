package com.kurt.bgmate.data.remote.llm

import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okio.IOException
import org.json.JSONArray
import org.json.JSONObject

class GeminiLlmClient(
    private val okHttpClient: OkHttpClient,
    private val apiKey: String
) : LlmClient {

    companion object {
        private const val TAG = "GeminiLlmClient"
        private const val BASE_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash"
        private const val GENERATE_CONTENT_URL = "$BASE_URL:generateContent"
        private const val STREAM_GENERATE_CONTENT_URL = "$BASE_URL:streamGenerateContent?alt=sse"

        // Gemini uses "model" instead of "assistant" for the assistant role
        private fun mapRole(role: String): String = when (role) {
            "assistant" -> "model"
            else -> role
        }
    }

    override suspend fun complete(request: LlmRequest): LlmResponse = withContext(Dispatchers.IO) {
        val body = buildRequestBody(request)

        val httpRequest = Request.Builder()
            .url(GENERATE_CONTENT_URL)
            .addHeader("x-goog-api-key", apiKey)
            .addHeader("content-type", "application/json")
            .post(body.toString().toRequestBody("application/json".toMediaType()))
            .build()

        val response = okHttpClient.newCall(httpRequest).execute()
        val responseBody = response.body.string()

        if (!response.isSuccessful) {
            throw IOException("Gemini API 오류 ${response.code}: $responseBody")
        }
        val text = extractTextFromResponse(responseBody)
        LlmResponse(text)
    }

    override fun stream(request: LlmRequest): Flow<String> = flow {
        val body = buildRequestBody(request)

        val httpRequest = Request.Builder()
            .url(STREAM_GENERATE_CONTENT_URL)
            .addHeader("x-goog-api-key", apiKey)
            .addHeader("content-type", "application/json")
            .post(body.toString().toRequestBody("application/json".toMediaType()))
            .build()

        val response = okHttpClient.newCall(httpRequest).execute()

        if (!response.isSuccessful) {
            throw IOException("Gemini API 오류 ${response.code}")
        }

        response.body.source().use { source ->
            while (!source.exhausted()) {
                val line = source.readUtf8Line() ?: break

                if (!line.startsWith("data: ")) continue

                val data = line.removePrefix("data: ")

                val chunk = runCatching {
                    extractTextFromResponse(data)
                }.getOrDefault("")

                if (chunk.isNotEmpty()) emit(chunk)
            }
        }
    }.flowOn(Dispatchers.IO)

    private fun buildRequestBody(request: LlmRequest): JSONObject = JSONObject().apply {
        request.systemPrompt?.let { prompt ->
            put("systemInstruction", JSONObject().apply {
                put("parts", JSONArray().apply {
                    put(JSONObject().apply { put("text", prompt) })
                })
            })
        }

        put("contents", JSONArray().apply {
            request.messages.forEach { msg ->
                put(JSONObject().apply {
                    put("role", mapRole(msg.role))
                    put("parts", JSONArray().apply {
                        put(JSONObject().apply { put("text", msg.content) })
                    })
                })
            }
        })

        put("generationConfig", JSONObject().apply {
            put("maxOutputTokens", request.maxTokens)
        })
    }

    private fun extractTextFromResponse(responseBody: String): String {
        val root = JSONObject(responseBody)
        val candidates = root.optJSONArray("candidates") ?: return ""
        if (candidates.length() == 0) return ""

        val candidate = candidates.getJSONObject(0)
        val finishReason = candidate.optString("finishReason")
        if (finishReason == "MAX_TOKENS") {
            Log.w(TAG, "Gemini 응답이 MAX_TOKENS로 중단되었습니다. maxTokens 값을 높이세요.")
        }

        val content = candidate.optJSONObject("content") ?: return ""
        val parts = content.optJSONArray("parts") ?: return ""

        // gemini-2.5-flash는 사고(thinking) 파트를 포함할 수 있음.
        // thought=true 파트는 내부 추론이므로 제외하고 실제 응답만 추출.
        val sb = StringBuilder()
        for (i in 0 until parts.length()) {
            val part = parts.getJSONObject(i)
            if (!part.optBoolean("thought", false)) {
                sb.append(part.optString("text", ""))
            }
        }
        return sb.toString()
    }
}
