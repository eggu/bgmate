package com.kurt.bgmate.presentation

sealed class Screen(val route: String) {
    object GameList : Screen("game_list")
    data class GameDetail(val id: Int) : Screen("detail/$id") {
        companion object {
            const val route: String = "detail/{id}"
        }
    }

    data class ScoreTracker(val bggId: String) : Screen("score_tracker/$bggId") {
        companion object {
            const val route: String = "score_tracker/{bggId}"
        }

        fun createRoute() = "score_tracker/$bggId"
    }
}

