package com.kurt.bgmate.data.remote

data class SearchResponse(val items: List<GameItem>) {

}

data class GameItem(val name: String, val id: String) {

}
