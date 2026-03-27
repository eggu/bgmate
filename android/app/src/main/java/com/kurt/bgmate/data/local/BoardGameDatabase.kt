package com.kurt.bgmate.data.local

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(
    entities = [BoardGameEntity::class],
    version = 1,
    exportSchema = false
)
abstract class BoardGameDatabase: RoomDatabase() {
    abstract fun gameDao(): BoardGameDao
}