package com.kurt.bgmate.presentation.recommend

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.Mood
import com.kurt.bgmate.domain.model.PlayTime
import com.kurt.bgmate.presentation.common.FilterChip
import com.kurt.bgmate.presentation.common.ObserveUiEvents
import com.kurt.bgmate.ui.theme.BGMateTheme

@Composable
fun RecommendScreen(
    modifier: Modifier = Modifier,
    viewModel: RecommendViewModel = hiltViewModel(),
) {
    val uiState = viewModel.uiState.collectAsStateWithLifecycle()

    ObserveUiEvents(viewModel.uiEvent)

    RecommendScreen(
        uiState = uiState.value,
        modifier = modifier,
        onPlayerCountSelected = viewModel::selectPlayerCount,
        onPlayTimeSelected = viewModel::selectPlayTime,
        onMoodToggled = viewModel::toggleMood,
        onRecommendClick = viewModel::recommend
    )
}

@Composable
private fun RecommendScreen(
    uiState: RecommendUiState,
    onPlayerCountSelected: (Int) -> Unit,
    onPlayTimeSelected: (PlayTime) -> Unit,
    onMoodToggled: (Mood) -> Unit,
    onRecommendClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp, vertical = 20.dp)
    ) {
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    text = "AI 게임 추천",
                    style = MaterialTheme.typography.headlineSmall
                )
                Text(
                    text = "함께할 인원, 원하는 플레이 시간, 분위기를 고르면 조건에 맞는 보드게임을 추천해드릴게요.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            ConditionSection(
                title = "인원수 선택",
                description = "함께 플레이할 인원을 선택해 주세요."
            ) {
                FlowRow(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    (1..8).forEach { count ->
                        FilterChip(
                            selected = uiState.selectedPlayerCount == count,
                            onClick = { onPlayerCountSelected(count) }
                        ) {
                            Text("${count}명")
                        }
                    }
                }
            }

            ConditionSection(
                title = "플레이 시간 선택",
                description = "대략 어느 정도 길이의 게임을 원하는지 골라 주세요."
            ) {
                FlowRow(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    PlayTime.entries.forEach { option ->
                        FilterChip(
                            selected = uiState.selectedPlayTime == option,
                            onClick = { onPlayTimeSelected(option) }
                        ) {
                            Text(option.label)
                        }
                    }
                }
            }

            ConditionSection(
                title = "분위기 선택",
                description = "원하는 분위기를 모두 선택해 주세요. 여러 개를 고를 수 있어요."
            ) {
                FlowRow(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    recommendMoods.forEach { mood ->
                        FilterChip(
                            selected = mood in uiState.selectedMoods,
                            onClick = { onMoodToggled(mood) }
                        ) {
                            Text(mood.label)
                        }
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = onRecommendClick,
            enabled = uiState.recommendEnabled,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("추천 받기")
        }
    }
}

@Composable
private fun ConditionSection(
    title: String,
    description: String,
    content: @Composable () -> Unit,
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(
                text = title,
                style = MaterialTheme.typography.titleMedium
            )
            Text(
                text = description,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        content()
    }
}

private val recommendMoods = listOf(
    Mood.STRATEGY,
    Mood.COOPERATIVE,
    Mood.DEDUCTION,
    Mood.COMPETITIVE,
    Mood.ROLE_PLAYING,
    Mood.PARTY,
    Mood.CREATIVE,
    Mood.DEXTERITY,
    Mood.RELAXED,
    Mood.CASUAL,
)

@Preview(showBackground = true)
@Composable
private fun RecommendScreenPreview() {
    BGMateTheme {
        RecommendScreen(
            uiState = RecommendUiState(
                selectedPlayerCount = 4,
                selectedPlayTime = PlayTime.MEDIUM,
                selectedMoods = setOf(Mood.STRATEGY, Mood.PARTY)
            ),
            onPlayerCountSelected = {},
            onPlayTimeSelected = {},
            onMoodToggled = {},
            onRecommendClick = {}
        )
    }
}
