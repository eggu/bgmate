package com.kurt.bgmate

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable

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

            val gameName = backStackEntry.arguments?.getString("gameName")
            GameDetailScreen(gameName = gameName, navController = navController, viewModel)
        }
    }
}

