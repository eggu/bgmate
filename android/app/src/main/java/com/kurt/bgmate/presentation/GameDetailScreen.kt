package com.kurt.bgmate.presentation

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.LocalViewModelStoreOwner
import androidx.navigation.NavBackStackEntry
import com.kurt.bgmate.preview.PreviewDummy

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GameDetailScreen(
    id: String? = null,
    onNavigateBack: () -> Unit = {},
    viewModel: GameListViewModel = hiltViewModel()
) {
    val backStackEntry = LocalViewModelStoreOwner.current as? NavBackStackEntry
    val resolvedId = id ?: backStackEntry?.arguments?.getString("id")
    val games by viewModel.games.collectAsStateWithLifecycle()
    val game = remember(games, resolvedId) {
        games.find { it.bggId == resolvedId }
    }
    val newGameNameState = remember(game?.bggId) {
        mutableStateOf(game?.name.orEmpty())
    }
    val newGameName = newGameNameState.value

    fun submitUpdate() {
        val updatedName = newGameName.trim()
        if (game != null && updatedName.isNotBlank()) {
            viewModel.updateGame(game.name, updatedName)
            onNavigateBack()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("게임 상세") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "뒤로"
                        )
                    }
                }
            )
        }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(24.dp),
            contentAlignment = Alignment.Center
        ) {
            if (game == null) {
                Text(
                    text = "게임 정보를 찾을 수 없습니다.",
                    style = MaterialTheme.typography.bodyLarge
                )
            } else {
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        elevation = CardDefaults.cardElevation(4.dp)
                    ) {
                        Column(modifier = Modifier.padding(24.dp)) {
                            Text(
                                text = "게임 이름 수정",
                                style = MaterialTheme.typography.titleMedium
                            )
                            Spacer(modifier = Modifier.height(12.dp))
                            TextField(
                                value = newGameName,
                                onValueChange = { newGameNameState.value = it },
                                label = { Text("게임 이름") },
                                modifier = Modifier.fillMaxWidth(),
                                keyboardActions = KeyboardActions(
                                    onDone = { submitUpdate() }
                                )
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Button(
                        onClick = { submitUpdate() },
                        enabled = newGameName.isNotBlank(),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("저장")
                    }

                    Spacer(modifier = Modifier.height(8.dp))

                    OutlinedButton(
                        onClick = onNavigateBack,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("취소")
                    }
                }
            }
        }
    }
}

@Preview
@Composable
fun PreviewGameDetailScreen() {
    GameDetailScreen(
        id = "1",
        viewModel = PreviewDummy.createGameListViewModel(LocalContext.current),
    )
}
