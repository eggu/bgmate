package com.kurt.bgmate

import javax.inject.Inject

class GameRepository @Inject constructor() {
    private val games = mutableListOf<String>()

    fun getGames(): List<String> = games.toList()
    fun addGame(name: String) { games.add(name) }
    fun removeGame(name: String) { games.remove(name) }
    fun updateGame(old: String, new: String) {
        val index = games.indexOf(old)
        if (index != -1) {
            games[index] = new
        }
    }
}