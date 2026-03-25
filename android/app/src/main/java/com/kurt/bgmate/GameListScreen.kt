package com.kurt.bgmate

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.key.Key
import androidx.compose.ui.input.key.KeyEventType
import androidx.compose.ui.input.key.key
import androidx.compose.ui.input.key.onPreviewKeyEvent
import androidx.compose.ui.input.key.type
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController

@Composable
fun GameListScreen(
    navController: NavController? = null,
    viewModel: GameListViewModel = viewModel()
) {
    val games by viewModel.items.collectAsState()
    var newGameName by remember { mutableStateOf("") }
    val submitNewGame = {
        viewModel.addItem(newGameName)
        newGameName = ""
    }

    Column(modifier = Modifier.padding(16.dp)) {
        OutlinedTextField(
            value = newGameName,
            onValueChange = { newGameName = it },
            label = { Text("게임 이름") },
            singleLine = true,
            keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
            keyboardActions = KeyboardActions(
                onDone = { submitNewGame() }
            ),
            modifier = Modifier.onPreviewKeyEvent { keyEvent ->
                if (keyEvent.type == KeyEventType.KeyUp && keyEvent.key == Key.Enter) {
                    submitNewGame()
                    true
                } else {
                    false
                }
            }
        )
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = submitNewGame) {
            Text("추가")
        }
        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn {
            items(games) { game ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable {
                            navController?.navigate("detail/${game}") { launchSingleTop = true }
                        }
                        .padding(vertical = 12.dp, horizontal = 4.dp)) {

                    Text(
                        text = game, modifier = Modifier
                            .weight(1f)
                            .padding(vertical = 8.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))

                    Button(onClick = { viewModel.removeItem(game) }) {
                        Icon(
                            imageVector = Icons.Default.Delete,
                            contentDescription = "삭제"
                        )
                    }
                }
            }
        }
    }

}

@Preview(showBackground = true)
@Composable
fun PreviewGameListScreen() {
    GameListScreen()
}