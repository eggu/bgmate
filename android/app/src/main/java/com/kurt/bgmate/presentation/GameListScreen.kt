package com.kurt.bgmate.presentation

import android.widget.Toast
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
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
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.BoardGame
import com.kurt.bgmate.preview.PreviewDummy
import com.kurt.bgmate.presentation.common.GameThumbnail
import com.kurt.bgmate.presentation.common.LoadingOverlay
import com.kurt.bgmate.presentation.common.ObserveUiEvents
import com.kurt.bgmate.ui.theme.BGMateTheme
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GameListScreen(
    onGameClick: (String) -> Unit = {},
    viewModel: GameListViewModel = hiltViewModel()
) {
    val showAddSheet by viewModel.showAddSheet.collectAsStateWithLifecycle()

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(onClick = viewModel::openAddSheet) {
                Icon(Icons.Default.Add, contentDescription = "게임 추가")
            }
        }
    ) { paddingValues ->
        GameListContent(
            modifier = Modifier.padding(paddingValues),
            onGameClick = onGameClick,
            viewModel = viewModel,
        )
    }

    if (showAddSheet) {
        AddGameBottomSheet(
            onDismiss = viewModel::closeAddSheet,
            onConfirm = { name -> viewModel.addGame(name) }
        )
    }
}

@Composable
fun GameListContent(
    modifier: Modifier,
    onGameClick: (String) -> Unit = {},
    viewModel: GameListViewModel
) {
    val games by viewModel.games.collectAsStateWithLifecycle()
    val searchResults by viewModel.searchResults.collectAsStateWithLifecycle()
    var searchQuery by remember { mutableStateOf("") }
    val isLoading by viewModel.isLoading.collectAsStateWithLifecycle()
    val error by viewModel.error.collectAsStateWithLifecycle()

    ObserveUiEvents(uiEvent = viewModel.uiEvent)

    LaunchedEffect(Unit) {
        snapshotFlow { searchQuery }
            .debounce(1200)
            .distinctUntilChanged()
            .collect { query ->
                viewModel.search(query)
            }
    }

    Column(modifier = modifier.padding(16.dp)) {
        OutlinedTextField(
            value = searchQuery,
            onValueChange = { searchQuery = it },
            label = { Text("게임 검색") },
            singleLine = true,
            leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
            trailingIcon = {
                if (searchQuery.isNotEmpty()) {
                    IconButton(onClick = {
                        searchQuery = ""
                        viewModel.search("")
                    }) {
                        Icon(Icons.Default.Clear, contentDescription = "검색어 지우기")
                    }
                }
            },
            modifier = Modifier.fillMaxWidth()
        )
        if (error != null) {
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = error!!,
                color = MaterialTheme.colorScheme.error
            )
        }
        Spacer(modifier = Modifier.height(8.dp))

        Box(modifier = Modifier.fillMaxSize()) {
            if (searchQuery.isBlank())
                MyCollections(games, onGameClick, viewModel)
            else
                SearchResults(
                    searchResults,
                    onGameClick = {
                        viewModel.addGame(it)
                        searchQuery = ""
                        viewModel.search("")
                    }
                )


            LoadingOverlay(isLoading)
        }
    }
}

@Composable
private fun MyCollections(
    games: List<BoardGame>,
    onGameClick: (String) -> Unit,
    viewModel: GameListViewModel
) {
    if (games.isEmpty()) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "아직 컬렉션에 게임이 없습니다.",
                    style = MaterialTheme.typography.titleMedium
                )
                Text(
                    text = "위 검색창에서 게임을 찾아 컬렉션에 추가해보세요.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        return
    }

    LazyColumn {
        items(games) { game ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onGameClick(game.bggId) }
                    .padding(vertical = 8.dp, horizontal = 4.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                GameThumbnail(thumbnailUrl = game.thumbnailUrl)
                Spacer(modifier = Modifier.width(12.dp))
                Text(
                    text = game.name,
                    modifier = Modifier
                        .weight(1f)
                        .padding(vertical = 8.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))

                IconButton(onClick = { onGameClick(game.bggId) }) {
                    Icon(
                        imageVector = Icons.Default.PlayArrow,
                        contentDescription = "점수 기록 시작"
                    )
                }

                IconButton(onClick = { viewModel.removeGame(game) }) {
                    Icon(
                        imageVector = Icons.Default.Delete,
                        contentDescription = "삭제"
                    )
                }
            }
        }
    }
}

@Composable
fun SearchResults(searchResults: List<BoardGame>, onGameClick: (BoardGame) -> Unit) {
    LazyColumn {
        items(searchResults) { game ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onGameClick(game) }
                    .padding(vertical = 8.dp, horizontal = 4.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                GameThumbnail(thumbnailUrl = game.thumbnailUrl)
                Spacer(modifier = Modifier.width(12.dp))
                Text(
                    text = game.name,
                    modifier = Modifier
                        .weight(1f)
                        .padding(vertical = 8.dp)
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddGameBottomSheet(
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    var text by remember { mutableStateOf("") }
    val focusRequester = remember { FocusRequester() }

    ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = sheetState
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp)
                .padding(bottom = 32.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(
                text = "게임 등록",
                style = MaterialTheme.typography.titleLarge
            )

            OutlinedTextField(
                value = text,
                onValueChange = { text = it },
                label = { Text("게임 이름") },
                singleLine = true,
                modifier = Modifier
                    .fillMaxWidth()
                    .focusRequester(focusRequester),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
                keyboardActions = KeyboardActions(
                    onDone = {
                        if (text.isNotBlank()) onConfirm(text)
                    }
                )
            )

            Button(
                onClick = { if (text.isNotBlank()) onConfirm(text) },
                enabled = text.isNotBlank(),
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("등록")
            }
        }
    }

    LaunchedEffect(Unit) {
        focusRequester.requestFocus()
    }
}

@Preview(showBackground = true)
@Composable
private fun PreviewGameListScreen() {
    BGMateTheme {
        GameListContent(
            modifier = Modifier,
            viewModel = PreviewDummy.createGameListViewModel(LocalContext.current)
        )
    }
}
