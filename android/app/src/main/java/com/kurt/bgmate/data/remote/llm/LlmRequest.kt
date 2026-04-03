package com.kurt.bgmate.data.remote.llm

data class LlmMessage(val role: String, val content: String)

data class LlmRequest(
    val messages: List<LlmMessage>,
    val systemPrompt: String? = null,
    val maxTokens: Int = 4096
)
