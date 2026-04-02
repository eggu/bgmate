package com.kurt.bgmate.presentation.scoretracker

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kurt.bgmate.domain.model.ScoreSession
import com.kurt.bgmate.preview.PreviewDummy
import com.kurt.bgmate.presentation.common.LoadingOverlay
import com.kurt.bgmate.presentation.common.ObserveUiEvents
import com.kurt.bgmate.ui.theme.BGMateTheme

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ScoreTrackerScreen(
    viewModel: ScoreTrackerViewModel = hiltViewModel(),
    onNavigateBack: () -> Unit
) {
    val session by viewModel.session.collectAsStateWithLifecycle()
    val isLoading by viewModel.isLoading.collectAsStateWithLifecycle()
    val isFinished by viewModel.isFinished.collectAsStateWithLifecycle()

    ObserveUiEvents(viewModel.uiEvent)

    ScoreTrackerScreenContent(
        session = session,
        isLoading = isLoading,
        isFinished = isFinished,
        onNavigateBack = onNavigateBack,
        inputContent = {
            ScoreInputContent(
                viewModel = viewModel,
                modifier = Modifier,
                onCancelSetup = onNavigateBack
            )
        }
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ScoreTrackerScreenContent(
    session: ScoreSession?,
    isLoading: Boolean,
    isFinished: Boolean,
    onNavigateBack: () -> Unit,
    inputContent: @Composable () -> Unit,
) {
    Box(modifier = Modifier.fillMaxSize()) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text(session?.game?.name ?: "") },
                    navigationIcon = {
                        if (!isFinished)
                            IconButton(onClick = onNavigateBack) {
                                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "뒤로")
                            }
                    }
                )
            }
        ) { paddingValues ->
            AnimatedContent(
                targetState = isFinished,
                transitionSpec = {
                    if (targetState) {
                        slideInHorizontally { it } togetherWith slideOutHorizontally { -it }
                    } else {
                        slideInHorizontally { -it } togetherWith slideOutHorizontally { it }
                    }
                },
                label = "score_tracker_content"
            ) { finished ->
                if (finished) {
                    ScoreResultContent(
                        session = session,
                        modifier = Modifier.padding(paddingValues),
                        onConfirm = onNavigateBack
                    )
                } else
                    Box(modifier = Modifier.padding(paddingValues)) {
                        inputContent()
                    }
            }
        }

        LoadingOverlay(isLoading)
    }
}

@Preview(showBackground = true)
@Composable
private fun PreviewScoreTrackerScreen() {
    BGMateTheme {
        ScoreTrackerScreenContent(
            session = PreviewDummy.sampleSession,
            isLoading = false,
            isFinished = true,
            onNavigateBack = {},
            inputContent = {}
        )
    }
}
