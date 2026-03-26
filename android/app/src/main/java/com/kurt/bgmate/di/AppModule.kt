package com.kurt.bgmate.di

import com.kurt.bgmate.data.repository.GameRepositoryImpl
import com.kurt.bgmate.domain.repository.GameRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Provides
    @Singleton
    fun provideGameRepository(): GameRepository = GameRepositoryImpl()
}

