package com.kurt.bgmate.presentation.recommend

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.relocation.BringIntoViewRequester
import androidx.compose.foundation.relocation.bringIntoViewRequester
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.ShoppingBag
import androidx.compose.material.icons.outlined.StarOutline
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.Mood
import com.kurt.bgmate.domain.model.PlayTime
import com.kurt.bgmate.domain.model.RecommendResult
import com.kurt.bgmate.presentation.common.FilterChip
import com.kurt.bgmate.presentation.common.ObserveUiEvents
import com.kurt.bgmate.ui.theme.BGMateTheme

@Composable
fun RecommendScreen(
    modifier: Modifier = Modifier,
    viewModel: RecommendViewModel = hiltViewModel(),
) {
    val uiState = viewModel.uiState.collectAsStateWithLifecycle()
    val isLoading = viewModel.isLoading.collectAsStateWithLifecycle()

    ObserveUiEvents(viewModel.uiEvent)

    RecommendScreen(
        uiState = uiState.value,
        isLoading = isLoading.value,
        onPlayerCountSelected = viewModel::selectPlayerCount,
        onPlayTimeSelected = viewModel::selectPlayTime,
        onMoodToggled = viewModel::toggleMood,
        onRecommendClick = viewModel::recommend,
        onToggleIncludeNew = viewModel::setIncludeNew,
        modifier = modifier,
    )
}

@Composable
private fun RecommendScreen(
    uiState: RecommendUiState,
    isLoading: Boolean,
    onPlayerCountSelected: (Int) -> Unit,
    onPlayTimeSelected: (PlayTime) -> Unit,
    onMoodToggled: (Mood) -> Unit,
    onRecommendClick: () -> Unit,
    onToggleIncludeNew: (Boolean) -> Unit,
    modifier: Modifier = Modifier,
) {
    val resultSectionVisible = uiState.hasRequested || isLoading
    val bringIntoViewRequester = remember { BringIntoViewRequester() }

    LaunchedEffect(resultSectionVisible, isLoading, uiState.results) {
        if (resultSectionVisible) {
            bringIntoViewRequester.bringIntoView()
        }
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp, vertical = 20.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        HeaderSection()

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

        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text("새 게임도 추천받기", style = MaterialTheme.typography.bodyMedium)
                Text(
                    if (uiState.includeNew) "보유 게임 우선, 더 잘 맞는 게임도 추천"
                    else "내 컬렉션 안에서만 추천",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            Switch(
                checked = uiState.includeNew,
                onCheckedChange = onToggleIncludeNew
            )
        }

        Button(
            onClick = onRecommendClick,
            enabled = uiState.recommendEnabled && !isLoading,
            modifier = Modifier.fillMaxWidth()
        ) {
            if (isLoading) {
                CircularProgressIndicator(
                    modifier = Modifier.size(18.dp),
                    strokeWidth = 2.dp,
                    color = MaterialTheme.colorScheme.onPrimary
                )
                Spacer(modifier = Modifier.size(8.dp))
                Text("추천 중...")
            } else {
                Text("추천 받기")
            }
        }

        RecommendResultSection(
            modifier = Modifier.bringIntoViewRequester(bringIntoViewRequester),
            results = uiState.results,
            hasRequested = uiState.hasRequested,
            isLoading = isLoading
        )
    }
}

@Composable
private fun HeaderSection() {
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
}

@Composable
private fun RecommendResultSection(
    modifier: Modifier = Modifier,
    results: List<RecommendResult>,
    hasRequested: Boolean,
    isLoading: Boolean,
) {
    if (!hasRequested && !isLoading) return

    ConditionSection(
        modifier = modifier,
        title = "추천 결과",
        description = when {
            isLoading -> "조건에 맞는 게임을 정리하고 있어요."
            results.isEmpty() -> "조건에 딱 맞는 추천을 찾지 못했어요. 분위기나 플레이 시간을 조금 넓혀보세요."
            else -> "선택한 조건을 바탕으로 잘 맞는 게임을 골라봤어요."
        }
    ) {
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            if (isLoading) {
                LoadingResultCard()
            } else if (results.isEmpty()) {
                EmptyResultCard()
            } else {
                results.forEachIndexed { index, result ->
                    RecommendResultCard(
                        rank = index + 1,
                        result = result
                    )
                }
            }
        }
    }
}

@Composable
private fun RecommendResultCard(
    rank: Int,
    result: RecommendResult,
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.Top,
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Surface(
                    color = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary,
                    shape = MaterialTheme.shapes.small
                ) {
                    Text(
                        text = rank.toString(),
                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp),
                        style = MaterialTheme.typography.labelLarge,
                        fontWeight = FontWeight.Bold
                    )
                }

                Column(
                    modifier = Modifier.weight(1f),
                    verticalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    Text(
                        text = result.name,
                        style = MaterialTheme.typography.titleMedium
                    )
                    OwnershipBadge(isOwned = result.isOwned)
                }
            }

            Text(
                text = result.reason,
                style = MaterialTheme.typography.bodyMedium
            )

            val scoreText = result.bggScore
                ?.takeIf { it > 0f }
                ?.let { String.format("%.1f", it) }
            val difficultyText = result.difficulty?.takeIf { it.isNotBlank() }

            if (scoreText != null || difficultyText != null) {
                HorizontalDivider()
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    scoreText?.let {
                        MetaItem(
                            icon = Icons.Outlined.StarOutline,
                            label = "BGG 평점",
                            value = it
                        )
                    }
                    difficultyText?.let {
                        MetaItem(
                            icon = Icons.Outlined.CheckCircle,
                            label = "난이도",
                            value = it
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun OwnershipBadge(isOwned: Boolean) {
    Surface(
        color = if (isOwned) {
            MaterialTheme.colorScheme.primaryContainer
        } else {
            MaterialTheme.colorScheme.secondaryContainer
        },
        contentColor = if (isOwned) {
            MaterialTheme.colorScheme.onPrimaryContainer
        } else {
            MaterialTheme.colorScheme.onSecondaryContainer
        },
        shape = MaterialTheme.shapes.small
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            Icon(
                imageVector = if (isOwned) Icons.Outlined.CheckCircle else Icons.Outlined.ShoppingBag,
                contentDescription = null,
                modifier = Modifier.size(14.dp)
            )
            Text(
                text = if (isOwned) "보유 중" else "새 게임",
                style = MaterialTheme.typography.labelMedium
            )
        }
    }
}

@Composable
private fun MetaItem(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    value: String,
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            modifier = Modifier.size(16.dp),
            tint = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Text(
            text = "$label $value",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun LoadingResultCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            CircularProgressIndicator(
                modifier = Modifier.size(20.dp),
                strokeWidth = 2.dp
            )
            Text(
                text = "추천 결과를 불러오고 있습니다.",
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}

@Composable
private fun EmptyResultCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Text(
            text = "추천 결과가 없어요. 선택한 분위기 수를 줄이거나 플레이 시간 조건을 바꿔서 다시 시도해 보세요.",
            modifier = Modifier.padding(16.dp),
            style = MaterialTheme.typography.bodyMedium
        )
    }
}

@Composable
private fun ConditionSection(
    modifier: Modifier = Modifier,
    title: String,
    description: String,
    content: @Composable () -> Unit,
) {
    Column(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
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
                selectedMoods = setOf(Mood.STRATEGY, Mood.PARTY),
                includeNew = true,
                hasRequested = true,
                results = listOf(
                    RecommendResult(
                        name = "스플렌더",
                        reason = "전략성과 적당한 러닝타임이 잘 맞고, 4명이 함께 부담 없이 즐기기 좋습니다.",
                        isOwned = true,
                        bggScore = 7.4f,
                        difficulty = "중간"
                    ),
                    RecommendResult(
                        name = "코드네임",
                        reason = "파티 분위기와 팀 플레이 감각이 살아 있어서 가볍게 몰입하기 좋습니다.",
                        isOwned = false,
                        bggScore = 7.6f,
                        difficulty = "쉬움"
                    )
                )
            ),
            isLoading = false,
            onPlayerCountSelected = {},
            onPlayTimeSelected = {},
            onMoodToggled = {},
            onRecommendClick = {},
            onToggleIncludeNew = {},
        )
    }
}
