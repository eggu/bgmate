package com.kurt.bgmate.presentation

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavController
import com.kurt.bgmate.preview.PreviewDummy
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged

@Composable
fun GameListScreen(
    navController: NavController? = null,
    viewModel: GameListViewModel = hiltViewModel()
) {
    val games by viewModel.games.collectAsStateWithLifecycle()
    var searchQuery by remember { mutableStateOf("") }
    val submitNewGame = {
        viewModel.addGame(searchQuery)
        searchQuery = ""
    }
    val isLoading by viewModel.isLoading.collectAsStateWithLifecycle()
    val error by viewModel.error.collectAsStateWithLifecycle()

    LaunchedEffect(Unit) {
        snapshotFlow { searchQuery }
            .debounce(300)
            .distinctUntilChanged()
            .collect { query ->
                viewModel.search(query) // ViewModel에 검색어 전달
            }
    }

    Column(modifier = Modifier.padding(16.dp)) {
        OutlinedTextField(
            value = searchQuery,
            onValueChange = { searchQuery = it },
            label = { Text("게임 검색") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )
        if (error != null) {
            Spacer(modifier = Modifier.width(16.dp))
            Text(
                text = error!!,
                color = MaterialTheme.colorScheme.error
            )
        }
        Spacer(modifier = Modifier.width(8.dp))
        //        Button(onClick = submitNewGame) {
        //            Text("추가")
        //        }
        //        Spacer(modifier = Modifier.height(16.dp))
        //        Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        //            Button(onClick = { viewModel.onClickLoad() }, enabled = !isLoading) {
        //                Text("불러오기")
        //            }
        //        }

        Box(modifier = Modifier.fillMaxSize()) {
            LazyColumn {
                items(games) { game ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable {
                                navController?.navigate("detail/${game}") {
                                    launchSingleTop = true
                                }
                            }
                            .padding(vertical = 12.dp, horizontal = 4.dp)
                    ) {
                        Text(
                            text = game, modifier = Modifier
                                .weight(1f)
                                .padding(vertical = 8.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))

                        Button(onClick = { viewModel.removeGame(game) }) {
                            Icon(
                                imageVector = Icons.Default.Delete,
                                contentDescription = "삭제"
                            )
                        }
                    }
                }
            }
            if (isLoading) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(Color(0x66FFFFFF))
                        .clickable(enabled = false) {}
                        .pointerInput(Unit) {
                            awaitPointerEventScope {
                                while (true) {
                                    val event = awaitPointerEvent()
                                    event.changes.forEach { it.consume() } // 터치/클릭 이벤트 소비
                                }
                            }
                        }
                ) {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center)
                    )
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun PreviewGameListScreen() {
    GameListScreen(
        navController = null,
        viewModel = PreviewDummy.createGameListViewModel(),
    )
}

