package com.kurt.bgmate.data.remote.llm

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

class ClaudeLlmClient(
    private val okHttpClient: OkHttpClient,
    private val apiKey: String
) : LlmClient {

    companion object {
        private const val API_URL = "https://api.anthropic.com/v1/messages"
        private const val MODEL = "claude-sonnet-4-6"
    }

    override suspend fun complete(request: LlmRequest): LlmResponse = withContext(Dispatchers.IO) {
        val body = JSONObject().apply {
            put("model", MODEL)
            put("max_tokens", request.maxTokens)
            request.systemPrompt?.let { put("system", it) }
            put("messages", JSONArray().apply {
                request.messages.forEach { msg ->
                    put(JSONObject().apply {
                        put("role", msg.role)
                        put("content", msg.content)
                    })
                }
            })
        }.toString().toRequestBody("application/json".toMediaType())

        val httpRequest = Request.Builder()
            .url(API_URL)
            .addHeader("x-api-key", apiKey)
            .addHeader("anthropic-version", "2023-06-01")
            .post(body)
            .build()

        val response = okHttpClient.newCall(httpRequest).execute()
        val responseBody = response.body.string()

        if (!response.isSuccessful) {
            throw IOException("Claude API 오류 ${response.code}: $responseBody")
        }

        val text = JSONObject(responseBody)
            .getJSONArray("content")
            .getJSONObject(0)
            .getString("text")

        LlmResponse(text)
    }

    override fun stream(request: LlmRequest): Flow<String> = flow {
        val body = JSONObject().apply {
            put("model", MODEL)
            put("max_tokens", request.maxTokens)
            put("stream", true)
            request.systemPrompt?.let { put("system", it) }
            put("messages", JSONArray().apply {
                request.messages.forEach { msg ->
                    put(JSONObject().apply {
                        put("role", msg.role)
                        put("content", msg.content)
                    })
                }
            })
        }.toString().toRequestBody("application/json".toMediaType())

        val httpRequest = Request.Builder()
            .url(API_URL)
            .addHeader("x-api-key", apiKey)
            .addHeader("anthropic-version", "2023-06-01")
            .addHeader("content-type", "application/json")
            .post(body)
            .build()

        val response = okHttpClient.newCall(httpRequest).execute()

        if (!response.isSuccessful) {
            throw IOException("API 오류 ${response.code}")
        }

        response.body.source().use { source ->
            while (!source.exhausted()) {
                val line = source.readUtf8Line() ?: break

                if (!line.startsWith("data: ")) continue

                val data = line.removePrefix("data: ")

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
