package com.kurt.bgmate.presentation.rulejudge

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.JudgeResult
import com.kurt.bgmate.presentation.common.LoadingOverlay
import com.kurt.bgmate.presentation.common.ObserveUiEvents
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun RuleJudgeScreen(viewModel: RuleJudgeViewModel = hiltViewModel()) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    val streamingText by viewModel.streamingText.collectAsStateWithLifecycle()
    val history by viewModel.history.collectAsStateWithLifecycle()

    var gameName by remember { mutableStateOf("") }
    var dispute by remember { mutableStateOf("") }

    val isLoading = uiState is RuleJudgeViewModel.UiState.Loading

    ObserveUiEvents(viewModel.uiEvent)

    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text("AI 규칙 판정관", style = MaterialTheme.typography.headlineSmall)

            // 게임 이름 입력
            OutlinedTextField(
                value = gameName,
                onValueChange = { gameName = it },
                label = { Text("게임 이름") },
                placeholder = { Text("예: 카탄, 아그리콜라") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading
            )

            // 분쟁 상황 입력
            OutlinedTextField(
                value = dispute,
                onValueChange = { dispute = it },
                label = { Text("분쟁 상황") },
                placeholder = { Text("어떤 상황인지 구체적으로 입력하세요.") },
                minLines = 4,
                maxLines = 6,
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading
            )

            // 판정 요청 버튼
            Button(
                onClick = { viewModel.judge(gameName, dispute) },
                enabled = !isLoading && gameName.isNotBlank() && dispute.isNotBlank(),
                modifier = Modifier.fillMaxWidth()
            ) {
                if (isLoading) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(18.dp),
                        strokeWidth = 2.dp,
                        color = MaterialTheme.colorScheme.onPrimary
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("판정 중...")
                } else {
                    Text("판정 요청")
                }
            }

            // 결과 영역
            AnimatedVisibility(
                visible = streamingText.isNotEmpty(),
                enter = fadeIn()
            ) {
                Card(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(
                            text = streamingText,
                            style = MaterialTheme.typography.bodyMedium
                        )

                        // 판정 완료 후 다시 질문 버튼
                        if (uiState is RuleJudgeViewModel.UiState.Result) {
                            Spacer(modifier = Modifier.height(12.dp))
                            OutlinedButton(
                                onClick = { viewModel.reset() },
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Text("다시 질문하기")
                            }
                        }
                    }
                }
            }

            // 에러 표시
            if (uiState is RuleJudgeViewModel.UiState.Error) {
                Text(
                    text = (uiState as RuleJudgeViewModel.UiState.Error).message,
                    color = MaterialTheme.colorScheme.error,
                    style = MaterialTheme.typography.bodySmall
                )
            }

            if (history.isNotEmpty()) {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "이전 판정 기록",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                history.forEach { result ->
                    JudgeHistoryCard(result = result)
                }
            }
        }

        // 로딩 중 터치 차단
        LoadingOverlay(isLoading)
    }
}

@Composable
fun JudgeHistoryCard(result: JudgeResult) {
    var expanded by remember { mutableStateOf(false) }

    val formattedDate = remember(result.askedAt) {
        SimpleDateFormat("MM.dd HH:mm", Locale.getDefault())
            .format(Date(result.askedAt))
    }

    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = { expanded = !expanded },   // 카드 전체가 탭 영역
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = result.gameName,
                    style = MaterialTheme.typography.labelLarge,
                    modifier = Modifier.weight(1f)
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = formattedDate,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Icon(
                        imageVector = if (expanded) Icons.Default.KeyboardArrowUp
                        else Icons.Default.KeyboardArrowDown,
                        contentDescription = if (expanded) "접기" else "펼치기",
                        modifier = Modifier.size(16.dp),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            Spacer(modifier = Modifier.height(4.dp))

            // 접힌 상태 — 3줄 요약
            // 펼친 상태 — 전체 답변
            Text(
                text = result.answer,
                style = MaterialTheme.typography.bodySmall,
                maxLines = if (expanded) Int.MAX_VALUE else 3,
                overflow = if (expanded) TextOverflow.Clip else TextOverflow.Ellipsis
            )
        }
    }
}