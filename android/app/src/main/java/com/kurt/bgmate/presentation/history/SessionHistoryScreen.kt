package com.kurt.bgmate.presentation.history

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.ScoreSession

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SessionHistoryScreen(
    viewModel: SessionHistoryViewModel = hiltViewModel(),
    onSessionClick: (Long) -> Unit,
    onNavigateBack: () -> Unit
) {
    val sessions by viewModel.sessions.collectAsStateWithLifecycle()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("전적 기록") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "뒤로")
                    }
                }
            )
        }
    ) { paddingValues ->
        if (sessions.isEmpty()) {
            // 빈 상태 — 기록 없음 안내
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
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
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .padding(horizontal = 16.dp),
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