package com.kurt.bgmate

import javax.inject.Inject

interface GameRepository {
    fun getGames(): List<String>
    fun addGame(name: String)
    fun removeGame(name: String)
    fun updateGame(old: String, new: String)
}

class GameRepositoryImpl @Inject constructor() : GameRepository {
    private val games = mutableListOf<String>()

    override fun getGames(): List<String> = games.toList()
    override fun addGame(name: String) {
        games.add(name)
    }

    override fun removeGame(name: String) {
        games.remove(name)
    }

    override fun updateGame(old: String, new: String) {
        val index = games.indexOf(old)
        if (index != -1) {
            games[index] = new
        }
    }
}