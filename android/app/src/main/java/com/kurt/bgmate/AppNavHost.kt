package com.kurt.bgmate

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
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
            val gameName = backStackEntry.arguments?.getString("gameName")
            GameDetailScreen(gameName = gameName, navController = navController)
        }
    }
}

