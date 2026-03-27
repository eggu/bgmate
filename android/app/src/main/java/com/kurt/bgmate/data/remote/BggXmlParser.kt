package com.kurt.bgmate.data.remote

import android.util.Xml
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
                        if (parser.getAttributeValue(null, "type") == "primary") {
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
}