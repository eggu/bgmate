package com.kurt.bgmate.presentation.history

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.ScoreSession
import com.kurt.bgmate.presentation.common.LoadingOverlay
import com.kurt.bgmate.presentation.common.ObserveUiEvents

@Composable
fun SessionHistoryScreen(
    viewModel: SessionHistoryViewModel = hiltViewModel(),
    onSessionClick: (Long) -> Unit
) {
    val isLoading by viewModel.isLoading.collectAsStateWithLifecycle()
    val sessions by viewModel.sessions.collectAsStateWithLifecycle()

    ObserveUiEvents(viewModel.uiEvent)

    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp, vertical = 20.dp)
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    text = "전적 기록",
                    style = MaterialTheme.typography.headlineSmall
                )
                Text(
                    text = "플레이했던 게임의 결과를 다시 보고, 누가 이겼는지 빠르게 확인할 수 있어요.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            Spacer(modifier = Modifier.height(20.dp))

            if (sessions.isEmpty()) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "아직 기록된 게임이 없습니다.",
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            } else {
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(
                        items = sessions,
                        key = { it.sessionId }
                    ) { session ->
                        SessionHistoryCard(
                            session = session,
                            onClick = { onSessionClick(session.sessionId) }
                        )
                    }
                }
            }
        }

        LoadingOverlay(isLoading)
    }
}

@Composable
fun SessionHistoryCard(
    session: ScoreSession,
    onClick: () -> Unit
) {
    val winner = session.players.firstOrNull()  // ViewModel에서 이미 정렬됨
    val dateText = remember(session.sessionId) {
        // playedAt 타임스탬프 → "3월 31일" 형식
        val sdf = java.text.SimpleDateFormat("M월 d일", java.util.Locale.KOREAN)
        sdf.format(java.util.Date(session.playedAt))
    }

    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = onClick
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = session.game.name,
                    style = MaterialTheme.typography.titleMedium
                )
                Text(
                    text = dateText,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            // 1위 이름 + 점수 요약
            winner?.let {
                Column(horizontalAlignment = Alignment.End) {
                    Text(
                        text = "🏆 ${it.name}",
                        style = MaterialTheme.typography.bodyMedium
                    )
                    Text(
                        text = "${it.totalScore}점",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary
                    )
                }
            }
        }
    }
}
