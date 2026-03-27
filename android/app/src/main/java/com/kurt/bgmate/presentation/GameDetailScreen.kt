package com.kurt.bgmate.presentation

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavHostController
import com.kurt.bgmate.preview.PreviewDummy

@Composable
fun GameDetailScreen(
    id: String?,
    navController: NavHostController? = null,
    viewModel: GameListViewModel = hiltViewModel()
) {
    val game by remember { mutableStateOf(viewModel.getGameById(id)) }
    var newGameName by remember { mutableStateOf(game?.name ?: "알 수 없는") }

    fun submitUpdate() {
        game?.let { viewModel.updateGame(it.name, newGameName) }
        navController?.popBackStack()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
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
                    onValueChange = { newGameName = it },
                    label = { Text("게임 이름") },
                    modifier = Modifier.fillMaxWidth(),
                    keyboardActions = KeyboardActions(
                        onDone = { submitUpdate() }
                    )
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedButton(onClick = {
                navController?.popBackStack()  // 수정 없이 복귀
            }) {
                Text("취소")
            }
            Button(onClick = { submitUpdate() }) {
                Text("저장")
            }
        }
    }
}

@Preview
@Composable
fun PreviewGameDetailScreen() {
    GameDetailScreen(
        1.toString(),
        viewModel = PreviewDummy.createGameListViewModel(LocalContext.current),
    )
}

