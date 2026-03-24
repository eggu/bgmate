package com.kurt.bgmate

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
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
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
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
import com.kurt.bgmate.ui.theme.BGMateTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            BGMateTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    GameListScreen(modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@Composable
fun GameListScreen(modifier: Modifier = Modifier) {
    var games by remember { mutableStateOf(listOf("카탄", "아줄", "스플렌더")) }
    var inputText by remember { mutableStateOf("") }
    val addGame = {
        val trimmedText = inputText.trim()
        if (trimmedText.isNotBlank()) {
            games = games + trimmedText
            inputText = ""
        }
    }

    Column(modifier = Modifier.padding(16.dp)) {
        OutlinedTextField(
            value = inputText,
            onValueChange = { inputText = it },
            label = { Text("게임 이름") },
            singleLine = true,
            keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
            keyboardActions = KeyboardActions(
                onDone = { addGame() }
            ),
            modifier = Modifier.onPreviewKeyEvent { keyEvent ->
                if (keyEvent.type == KeyEventType.KeyUp && keyEvent.key == Key.Enter) {
                    addGame()
                    true
                } else {
                    false
                }
            }
        )
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = addGame) {
            Text("추가")
        }
        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn {
            items(games) { game ->
                Row(modifier = Modifier.fillMaxWidth()) {

                    Text(
                        text = game, modifier = Modifier
                            .weight(1f)
                            .padding(vertical = 8.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))

                    Button(onClick = { games = games - game }) {
                        Icon(
                            imageVector = Icons.Filled.Delete,
                            contentDescription = "삭제"
                        )
                    }
                }
            }
        }
    }

}

@Preview
@Composable
fun PreviewGameListScreen() {
    GameListScreen()
}