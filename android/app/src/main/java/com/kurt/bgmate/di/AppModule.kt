package com.kurt.bgmate.di

import android.content.Context
import androidx.room.Room
import com.kurt.bgmate.data.local.BoardGameDao
import com.kurt.bgmate.data.local.BoardGameDatabase
import com.kurt.bgmate.data.local.SessionDao
import com.kurt.bgmate.data.remote.BggApiService
import com.kurt.bgmate.data.remote.BggRemoteDataSource
import com.kurt.bgmate.data.repository.GameRepositoryImpl
import com.kurt.bgmate.data.repository.RuleJudgeRepositoryImpl
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.domain.repository.RuleJudgeRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.scalars.ScalarsConverterFactory
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Provides
    @Singleton
    fun provideOkHttpClient(): OkHttpClient = OkHttpClient.Builder()
        .addInterceptor(
            HttpLoggingInterceptor().apply {
                level = HttpLoggingInterceptor.Level.BODY
            }
        )
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build()

    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit = Retrofit.Builder()
        .baseUrl("https://www.boardgamegeek.com/")
        .addConverterFactory(ScalarsConverterFactory.create())
        .client(okHttpClient)
        .build()

    @Provides
    @Singleton
    fun provideBggApiService(retrofit: Retrofit): BggApiService =
        retrofit.create(BggApiService::class.java)

    @Provides
    @Singleton
    fun provideBggRemoteDataSource(@ApplicationContext context: Context): BggRemoteDataSource =
        BggRemoteDataSource(context)

    @Provides
    @Singleton
    fun provideGameRepository(
        gameDao: BoardGameDao,
        sessionDao: SessionDao,
        remoteDataSource: BggRemoteDataSource
    ): GameRepository =
        GameRepositoryImpl(gameDao, sessionDao, remoteDataSource)

    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext context: Context): BoardGameDatabase =
        Room.databaseBuilder(context, BoardGameDatabase::class.java, "bgmate.db")
            .fallbackToDestructiveMigration(true)
            .build()

    @Provides
    fun provideGameDao(database: BoardGameDatabase) = database.gameDao()

    @Provides
    fun provideSessionDao(database: BoardGameDatabase) = database.sessionDao()

    @Provides
    @Singleton
    fun provideRuleJudgeRepository(
        okHttpClient: OkHttpClient,
        @ApplicationContext context: Context
    ): RuleJudgeRepository =
        RuleJudgeRepositoryImpl(okHttpClient, context)
}

