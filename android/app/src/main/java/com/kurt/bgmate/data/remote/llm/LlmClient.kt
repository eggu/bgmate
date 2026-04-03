package com.kurt.bgmate.data.remote.llm

import kotlinx.coroutines.flow.Flow

interface LlmClient {
    suspend fun complete(request: LlmRequest): LlmResponse
    fun stream(request: LlmRequest): Flow<String>
}
