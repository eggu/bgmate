package com.kurt.bgmate

sealed class Screen(val route: String) {
    object GameList: Screen("game_list")
    data class GameDetail(val gameName: String): Screen("detail/$gameName") {
        companion object { const val route = "detail/{gameName}"}
    }
}