package com.kurt.bgmate.data.local

import com.kurt.bgmate.domain.model.BoardGame
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class BoardGameEntityMapperTest {

    @Test
    fun `toDomain - 모든 필드가 올바르게 매핑된다`() {
        val entity = BoardGameEntity(
            bggId = "174430",
            name = "Gloomhaven",
            yearPublished = "2017",
            thumbnailUrl = "https://example.com/thumb.jpg"
        )

        val domain = entity.toDomain()

        assertEquals("174430", domain.bggId)
        assertEquals("Gloomhaven", domain.name)
        assertEquals("2017", domain.yearPublished)
        assertEquals("https://example.com/thumb.jpg", domain.thumbnailUrl)
    }

    @Test
    fun `toDomain - nullable 필드가 null일 때 null로 유지된다`() {
        val entity = BoardGameEntity(
            bggId = "174430",
            name = "Gloomhaven"
        )

        val domain = entity.toDomain()

        assertNull(domain.yearPublished)
        assertNull(domain.thumbnailUrl)
    }

    @Test
    fun `toEntity - 모든 필드가 올바르게 매핑된다`() {
        val domain = BoardGame(
            bggId = "174430",
            name = "Gloomhaven",
            yearPublished = "2017",
            thumbnailUrl = "https://example.com/thumb.jpg"
        )

        val entity = domain.toEntity()

        assertEquals("174430", entity.bggId)
        assertEquals("Gloomhaven", entity.name)
        assertEquals("2017", entity.yearPublished)
        assertEquals("https://example.com/thumb.jpg", entity.thumbnailUrl)
    }

    @Test
    fun `toEntity - nullable 필드가 null일 때 null로 유지된다`() {
        val domain = BoardGame(
            bggId = "174430",
            name = "Gloomhaven"
        )

        val entity = domain.toEntity()

        assertNull(entity.yearPublished)
        assertNull(entity.thumbnailUrl)
    }

    @Test
    fun `toDomain 후 toEntity - 왕복 변환 시 값이 보존된다`() {
        val original = BoardGameEntity(
            bggId = "13",
            name = "Catan",
            yearPublished = "1995",
            thumbnailUrl = null
        )

        val roundTripped = original.toDomain().toEntity()

        assertEquals(original.bggId, roundTripped.bggId)
        assertEquals(original.name, roundTripped.name)
        assertEquals(original.yearPublished, roundTripped.yearPublished)
        assertEquals(original.thumbnailUrl, roundTripped.thumbnailUrl)
    }
}
