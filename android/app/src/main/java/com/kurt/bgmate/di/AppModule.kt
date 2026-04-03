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
import com.kurt.bgmate.data.remote.llm.GeminiLlmClient
import com.kurt.bgmate.data.remote.llm.LlmClient
// import com.kurt.bgmate.data.remote.llm.ClaudeLlmClient  // Claude 롤백용: 주석 해제하여 사용
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
    @Named("llm")
    fun provideLlmOkHttpClient(): OkHttpClient =
        OkHttpClient.Builder()
            .addInterceptor(
                HttpLoggingInterceptor().apply {
                    level = HttpLoggingInterceptor.Level.BODY
                }
            )
            .connectTimeout(60, TimeUnit.SECONDS)
            .readTimeout(120, TimeUnit.SECONDS)
            .build()

    @Provides
    @Singleton
    fun provideLlmClient(@Named("llm") okHttpClient: OkHttpClient): LlmClient {
        // Gemini 사용 (현재 활성)
        return GeminiLlmClient(okHttpClient, BuildConfig.GEMINI_API_KEY)

        // Claude 롤백: 아래 주석 해제하고 위 줄 주석 처리
        // return ClaudeLlmClient(okHttpClient, BuildConfig.CLAUDE_API_KEY)
    }

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
        llmClient: LlmClient,
        judgeHistoryDao: JudgeHistoryDao,
        @ApplicationContext context: Context
    ): RuleJudgeRepository =
        RuleJudgeRepositoryImpl(llmClient, judgeHistoryDao, context)

    @Provides
    @Singleton
    fun provideRecommendRepository(
        llmClient: LlmClient,
        @ApplicationContext context: Context
    ): RecommendRepository =
        RecommendRepositoryImpl(llmClient, context)

    @Provides
    @Named("bgg_api_token")
    fun provideBggApiToken(): String = BuildConfig.BGG_API_TOKEN
}
