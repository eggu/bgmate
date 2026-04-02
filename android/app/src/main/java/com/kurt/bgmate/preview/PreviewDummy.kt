package com.kurt.bgmate.preview

import android.content.Context
import androidx.room.Room
import com.kurt.bgmate.data.local.BoardGameDatabase
import com.kurt.bgmate.data.remote.BggMockRemoteDataSource
import com.kurt.bgmate.data.repository.GameRepositoryImpl
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.domain.model.JudgeResult
import com.kurt.bgmate.domain.model.PlayerScore
import com.kurt.bgmate.domain.model.ScoreSession
import com.kurt.bgmate.presentation.GameListViewModel

/**
 * Android Studio Preview에서 Hilt가 제대로 주입되지 않는 경우를 대비한 공통 더미 헬퍼입니다.
 */
object PreviewDummy {
    private val previewGames = listOf("카탄", "아줄", "스플렌더")
    val sampleBoardGames = listOf(
        BoardGame(bggId = "1", name = "카탄", yearPublished = "1995"),
        BoardGame(bggId = "2", name = "아줄", yearPublished = "2017"),
        BoardGame(bggId = "3", name = "스플렌더", yearPublished = "2014")
    )

    val sampleSession = ScoreSession(
        sessionId = 1L,
        game = BoardGame(bggId = "1", name = "카탄"),
        players = listOf(
            PlayerScore(playerId = 1L, name = "민수", totalScore = 12),
            PlayerScore(playerId = 2L, name = "지연", totalScore = 10),
            PlayerScore(playerId = 3L, name = "현우", totalScore = 8),
        ),
        playedAt = 1_744_004_800_000L
    )

    val sampleSessions = listOf(
        sampleSession,
        ScoreSession(
            sessionId = 2L,
            game = BoardGame(bggId = "2", name = "스플렌더"),
            players = listOf(
                PlayerScore(playerId = 4L, name = "서연", totalScore = 16),
                PlayerScore(playerId = 5L, name = "도윤", totalScore = 14),
            ),
            playedAt = 1_744_091_200_000L
        )
    )

    val sampleJudgeHistory = listOf(
        JudgeResult(
            gameName = "카탄",
            dispute = "도로를 둘 수 있는 위치인지 궁금해요.",
            answer = "기존 도로와 이어져 있고 다른 플레이어의 정착지에 막히지 않았다면 놓을 수 있습니다.",
            askedAt = 1_744_004_800_000L
        ),
        JudgeResult(
            gameName = "아그리콜라",
            dispute = "가축 우리 계산이 헷갈려요.",
            answer = "울타리로 닫힌 공간마다 수용 가능한 가축 수를 따로 계산하면 됩니다.",
            askedAt = 1_744_091_200_000L
        )
    )

    fun createGameListViewModel(context: Context): GameListViewModel {
        val db = Room.inMemoryDatabaseBuilder(context, BoardGameDatabase::class.java)
            .allowMainThreadQueries()
            .build()
        val repository =
            GameRepositoryImpl(db.gameDao(), db.sessionDao(), BggMockRemoteDataSource(context))
        val viewModel = GameListViewModel(repository = repository)
        // ViewModel의 StateFlow은 add/remove/update에서 갱신되므로 미리 seed를 넣습니다.
        previewGames.forEach { viewModel.addGame(it) }
        return viewModel
    }
}
