package com.kurt.bgmate.data.local

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(
    entities = [BoardGameEntity::class, SessionEntity::class, PlayerEntity::class, ScoreEntryEntity::class],
    version = 4,
    exportSchema = false
)
abstract class BoardGameDatabase: RoomDatabase() {
    abstract fun gameDao(): BoardGameDao
    abstract fun sessionDao(): SessionDao
}