package com.kurt.bgmate.presentation.scoretracker

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SheetValue
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.PlayerScore

@Composable
fun ScoreInputContent(
    viewModel: ScoreTrackerViewModel,
    modifier: Modifier
) {
    val session by viewModel.session.collectAsStateWithLifecycle()
    val showPlayerSetupSheet by viewModel.showPlayerSetupSheet.collectAsStateWithLifecycle()
    val pendingPlayerNames by viewModel.pendingPlayerNames.collectAsStateWithLifecycle()

    val maxScore = remember(session) {
        session?.players?.maxOfOrNull { it.totalScore } ?: 0
    }

    // session이 null이거나 시트가 열려 있으면 시트 표시
    if (showPlayerSetupSheet || session == null) {
        PlayerSetupBottomSheet(
            playerNames = pendingPlayerNames,
            onAddPlayer = { viewModel.addPendingPlayer(it) },
            onRemovePlayer = { viewModel.removePendingPlayer(it) },
            onConfirm = { viewModel.confirmPlayers() }
        )
    }

    Column(modifier = modifier.fillMaxSize()) {
        LazyColumn(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(
                items = session?.players ?: emptyList(),
                key = { it.playerId }) { player ->
                PlayerScoreCard(
                    player = player,
                    isLeader = player.totalScore > 0 && player.totalScore == maxScore,
                    modifier = Modifier.animateItem()
                ) { score: Int -> viewModel.setScore(player.playerId, score) }
            }
        }
        Button(
            onClick = { viewModel.finishSession() },
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
        ) {
            Text("게임 종료")
        }
    }
}

@Composable
fun PlayerScoreCard(
    player: PlayerScore,
    isLeader: Boolean,
    modifier: Modifier,
    onScoreChange: (Int) -> Unit
) {
    var text by remember(player.playerId) { mutableStateOf(player.totalScore.toString()) }
    val borderColor by animateColorAsState(
        targetValue = if (isLeader) MaterialTheme.colorScheme.primary else Color.Transparent,
        label = "leader_border"
    )

    fun changeScoreIfChanged() {
        text.toIntOrNull()?.let { onScoreChange(it) }
    }

    Card(
        modifier = modifier
            .fillMaxWidth()
            .border(2.dp, borderColor, shape = CardDefaults.shape)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            AnimatedVisibility(visible = isLeader) {
                Icon(
                    imageVector = Icons.Default.Star,
                    contentDescription = "1위",
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(end = 8.dp)
                )
            }
            Text(
                text = player.name,
                modifier = Modifier.weight(1f)
            )
            OutlinedTextField(
                value = text,
                onValueChange = { input ->
                    text = input
                },
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done
                ),
                keyboardActions = KeyboardActions(
                    onDone = {
                        changeScoreIfChanged()
                    }
                ),
                singleLine = true,
                modifier = Modifier
                    .width(100.dp)
                    .onFocusChanged { focusState ->
                        if (!focusState.isFocused) {
                            changeScoreIfChanged()
                        }
                    },
                textStyle = LocalTextStyle.current.copy(textAlign = TextAlign.End)
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PlayerSetupBottomSheet(
    playerNames: List<String>,
    onAddPlayer: (String) -> Unit,
    onRemovePlayer: (Int) -> Unit,
    onConfirm: () -> Unit
) {
    var text by remember { mutableStateOf("") }
    val focusRequester = remember { FocusRequester() }

    // 시트가 열릴 때 키보드 자동 포커스 (Day 7+8 패턴 재활용)
    LaunchedEffect(Unit) {
        focusRequester.requestFocus()
    }

    ModalBottomSheet(
        onDismissRequest = { /* 플레이어 없이 닫기 불가 — 무시 */ },
        sheetState = rememberModalBottomSheetState(
            skipPartiallyExpanded = true,
            confirmValueChange = { newValue -> newValue != SheetValue.Hidden }
        )
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("플레이어 추가", style = MaterialTheme.typography.titleLarge)
            Spacer(modifier = Modifier.height(12.dp))

            // 이름 입력창
            OutlinedTextField(
                value = text,
                onValueChange = { text = it },
                placeholder = { Text("이름 입력") },
                trailingIcon = {
                    IconButton(onClick = {
                        onAddPlayer(text)
                        text = ""
                    }) {
                        Icon(Icons.Default.Add, contentDescription = "추가")
                    }
                },
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
                keyboardActions = KeyboardActions(onDone = {
                    onAddPlayer(text)
                    text = ""
                }),
                singleLine = true,
                modifier = Modifier
                    .fillMaxWidth()
                    .focusRequester(focusRequester)
            )

            Spacer(modifier = Modifier.height(8.dp))

            // 추가된 플레이어 목록
            playerNames.forEachIndexed { index, name ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = name,
                        modifier = Modifier.weight(1f),
                        style = MaterialTheme.typography.bodyLarge
                    )
                    IconButton(onClick = { onRemovePlayer(index) }) {
                        Icon(Icons.Default.Close, contentDescription = "삭제")
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // 2명 이상일 때만 시작 가능
            Button(
                onClick = onConfirm,
                enabled = playerNames.size >= 2,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("게임 시작")
            }
        }
    }
}
