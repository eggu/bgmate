package com.kurt.bgmate.presentation

object Screen {
    const val GAME_LIST = "game_list"
    const val GAME_DETAIL = "detail/{id}"
    fun gameDetail(id: String) = "detail/$id"

    const val SCORE_TRACKER = "score_tracker/{bggId}"
    fun scoreTracker(bggId: String) = "score_tracker/$bggId"

    // 규칙 판정관 탭
    const val RULE_JUDGE = "rule_judge"

    // 전적 기록 탭
    const val SESSION_HISTORY = "session_history"
    const val SESSION_DETAIL = "session_detail/{sessionId}"
    fun sessionDetail(sessionId: Long) = "session_detail/$sessionId"
}
