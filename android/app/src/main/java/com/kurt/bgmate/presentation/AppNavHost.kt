package com.kurt.bgmate.presentation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.kurt.bgmate.presentation.scoretracker.ScoreTrackerScreen

@Composable
fun AppNavHost(navController: NavHostController, modifier: Modifier = Modifier) {
    NavHost(
        navController = navController,
        startDestination = Screen.GameList.route,
        modifier = modifier,
    ) {
        composable(Screen.GameList.route) { GameListScreen(navController = navController) }
        composable(Screen.GameDetail.route) { backStackEntry ->
            val gameListBackStackEntry = remember(navController) {
                navController.getBackStackEntry(Screen.GameList.route)
            }

            val viewModel: GameListViewModel = hiltViewModel(gameListBackStackEntry)

            val id = backStackEntry.arguments?.getString("id")
            GameDetailScreen(id, navController = navController, viewModel)
        }
        composable(
            Screen.ScoreTracker("{bggId}").createRoute(),
            arguments = listOf(navArgument("bggId") { type = NavType.StringType })
        ) {
            ScoreTrackerScreen { navController.popBackStack() }
        }
    }
}

