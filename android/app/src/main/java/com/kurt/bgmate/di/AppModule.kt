package com.kurt.bgmate.di

import android.content.Context
import androidx.room.Room
import com.kurt.bgmate.BuildConfig
import com.kurt.bgmate.data.local.BoardGameDao
import com.kurt.bgmate.data.local.BoardGameDatabase
import com.kurt.bgmate.data.local.JudgeHistoryDao
import com.kurt.bgmate.data.local.SessionDao
import com.kurt.bgmate.data.remote.BggApiRemoteDataSource
import com.kurt.bgmate.data.remote.BggApiService
import com.kurt.bgmate.data.remote.BggRemoteDataSource
import com.kurt.bgmate.data.repository.GameRepositoryImpl
import com.kurt.bgmate.data.repository.RecommendRepositoryImpl
import com.kurt.bgmate.data.repository.RuleJudgeRepositoryImpl
import com.kurt.bgmate.domain.repository.GameRepository
import com.kurt.bgmate.domain.repository.RecommendRepository
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
import javax.inject.Named
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Provides
    @Singleton
    fun provideOkHttpClient(@Named("bgg_api_token") token: String): OkHttpClient =
        OkHttpClient.Builder()
            .addInterceptor { chain ->
                val request = chain.request().newBuilder()
                    .header("Authorization", "Bearer $token")
                    .build()
                chain.proceed(request)
            }
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
        .baseUrl("https://boardgamegeek.com/")
        .addConverterFactory(ScalarsConverterFactory.create())
        .client(okHttpClient)
        .build()

    @Provides
    @Singleton
    fun provideBggApiService(retrofit: Retrofit): BggApiService =
        retrofit.create(BggApiService::class.java)

    @Provides
    @Singleton
    fun provideBggRemoteDataSource(bggApiService: BggApiService): BggRemoteDataSource =
        BggApiRemoteDataSource(bggApiService)

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
    fun provideJudgeHistoryDao(database: BoardGameDatabase) = database.judgeHistoryDao()

    @Provides
    @Singleton
    fun provideRuleJudgeRepository(
        okHttpClient: OkHttpClient,
        judgeHistoryDao: JudgeHistoryDao,
        @ApplicationContext context: Context
    ): RuleJudgeRepository =
        RuleJudgeRepositoryImpl(okHttpClient, judgeHistoryDao, context)

    @Provides
    @Singleton
    fun provideRecommendRepository(
        okHttpClient: OkHttpClient,
        @ApplicationContext context: Context
    ): RecommendRepository =
        RecommendRepositoryImpl(okHttpClient, context)


    @Provides
    @Named("bgg_api_token")
    fun provideBggApiToken(): String = BuildConfig.BGG_API_TOKEN
}
