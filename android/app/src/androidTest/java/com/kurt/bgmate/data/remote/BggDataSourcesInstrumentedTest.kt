package com.kurt.bgmate.data.remote

import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class BggDataSourcesInstrumentedTest {

    @Test
    fun parseSearchResult_readsPrimaryNameAndYear() {
        val xml = """
            <items>
                <item type="boardgame" id="13">
                    <name type="primary" value="Catan" />
                    <yearpublished value="1995" />
                </item>
                <item type="boardgame" id="42">
                    <name type="primary" value="Tigris &amp; Euphrates" />
                </item>
            </items>
        """.trimIndent()

        val result = BggXmlParser.parseSearchResult(xml)

        assertEquals(2, result.size)
        assertEquals(BggXmlParser.BggSearchItem("13", "Catan", "1995"), result[0])
        assertEquals(BggXmlParser.BggSearchItem("42", "Tigris & Euphrates", null), result[1])
    }

    @Test
    fun parseSearchResult_usesAlternateNameWhenPrimaryMissing() {
        val xml = """
            <items>
                <item type="boardgame" id="100">
                    <name type="alternate" value="Alt Name" />
                </item>
            </items>
        """.trimIndent()

        val result = BggXmlParser.parseSearchResult(xml)

        assertEquals(listOf(BggXmlParser.BggSearchItem("100", "Alt Name", null)), result)
    }

    @Test
    fun apiRemoteDataSource_mapsXmlResponseToDomainModel() = runBlocking {
        val xml = """
            <items>
                <item type="boardgame" id="174430">
                    <name type="primary" value="Gloomhaven" />
                    <yearpublished value="2017" />
                </item>
            </items>
        """.trimIndent()
        val service = object : BggApiService {
            override suspend fun searchGames(query: String, type: String): String = xml
            override suspend fun getGameDetail(gameId: String): String = ""
        }

        val result = BggApiRemoteDataSource(service).searchGames("gloomhaven")

        assertEquals(1, result.size)
        assertEquals("174430", result[0].bggId)
        assertEquals("Gloomhaven", result[0].name)
        assertEquals("2017", result[0].yearPublished)
    }

    @Test
    fun apiRemoteDataSource_returnsEmptyListOnException() = runBlocking {
        val service = object : BggApiService {
            override suspend fun searchGames(query: String, type: String): String {
                throw IllegalStateException("network")
            }

            override suspend fun getGameDetail(gameId: String): String = ""
        }

        val result = BggApiRemoteDataSource(service).searchGames("catan")

        assertTrue(result.isEmpty())
    }

    @Test
    fun mockRemoteDataSource_readsAssetXmlIntoDomainModels() = runBlocking {
        val context = InstrumentationRegistry.getInstrumentation().targetContext

        val result = BggMockRemoteDataSource(context).searchGames("catan")

        assertEquals(5, result.size)
        assertEquals("13", result.first().bggId)
        assertEquals("Catan", result.first().name)
        assertEquals("2017", result.last().yearPublished)
    }
}
