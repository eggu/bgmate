package com.kurt.bgmate.data.remote

import android.util.Xml
import com.kurt.bgmate.domain.model.BoardGame
import org.xmlpull.v1.XmlPullParser

// data/remote/BggXmlParser.kt
object BggXmlParser {

    data class BggSearchItem(
        val id: String,
        val name: String,
        val year: String?
    )

    fun parseSearchResult(xml: String): List<BggSearchItem> {
        val results = mutableListOf<BggSearchItem>()
        val parser = Xml.newPullParser()
        parser.setInput(xml.reader())

        var currentId = ""
        var currentName = ""
        var currentYear: String? = null

        var eventType = parser.eventType
        while (eventType != XmlPullParser.END_DOCUMENT) {
            when (eventType) {
                XmlPullParser.START_TAG -> when (parser.name) {
                    "item" -> {
                        currentId = parser.getAttributeValue(null, "id") ?: ""
                        currentName = ""
                        currentYear = null
                    }

                    "name" -> {
                        val type = parser.getAttributeValue(null, "type")
                        if (type == "primary" || type == "alternate") {
                            currentName = parser.getAttributeValue(null, "value") ?: ""
                        }
                    }

                    "yearpublished" -> {
                        currentYear = parser.getAttributeValue(null, "value")
                    }
                }

                XmlPullParser.END_TAG -> {
                    if (parser.name == "item" && currentId.isNotEmpty()) {
                        results.add(BggSearchItem(currentId, currentName, currentYear))
                    }
                }
            }
            eventType = parser.next()
        }
        return results
    }

    fun parseThingThumbnails(xml: String): Map<String, String> {
        val result = mutableMapOf<String, String>()
        val parser = Xml.newPullParser()
        parser.setInput(xml.reader())

        var currentId = ""
        var insideThumbnail = false

        var eventType = parser.eventType
        while (eventType != XmlPullParser.END_DOCUMENT) {
            when (eventType) {
                XmlPullParser.START_TAG -> when (parser.name) {
                    "item" -> currentId = parser.getAttributeValue(null, "id") ?: ""
                    "thumbnail" -> insideThumbnail = true
                }
                XmlPullParser.TEXT -> {
                    if (insideThumbnail && currentId.isNotEmpty()) {
                        val url = parser.text?.trim() ?: ""
                        if (url.isNotEmpty()) result[currentId] = url
                    }
                }
                XmlPullParser.END_TAG -> {
                    if (parser.name == "thumbnail") insideThumbnail = false
                }
            }
            eventType = parser.next()
        }
        return result
    }
}

fun BggXmlParser.BggSearchItem.toDomain(): BoardGame =
    BoardGame(bggId = id, name = name, yearPublished = year)