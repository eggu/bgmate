package com.kurt.bgmate.presentation

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import androidx.navigation.navigation
import com.kurt.bgmate.presentation.history.SessionDetailScreen
import com.kurt.bgmate.presentation.history.SessionHistoryScreen
import com.kurt.bgmate.presentation.recommend.RecommendScreen
import com.kurt.bgmate.presentation.rulejudge.RuleJudgeScreen
import com.kurt.bgmate.presentation.scoretracker.ScoreTrackerScreen

@Composable
fun AppNavHost(navController: NavHostController, modifier: Modifier = Modifier) {
    NavHost(
        navController = navController,
        startDestination = BottomNavItem.Collection.route,
        modifier = modifier,
    ) {
        // ── 탭 1: 컬렉션 ──────────────────────────────────
        navigation(startDestination = BottomNavItem.Collection.root, route = BottomNavItem.Collection.route) {

            composable(Screen.GAME_LIST) {
                GameListScreen(onGameClick = { bggId ->
                    navController.navigate(Screen.scoreTracker(bggId))
                })
            }
            composable(
                Screen.GAME_DETAIL,
                arguments = listOf(navArgument("id") { type = NavType.StringType })
            ) {
                GameDetailScreen(onNavigateBack = { navController.popBackStack() })
            }
            composable(
                Screen.SCORE_TRACKER,
                arguments = listOf(navArgument("bggId") { type = NavType.StringType })
            ) {
                ScoreTrackerScreen { navController.popBackStack() }
            }
        }

        // ── 탭 2: 게임 추천 ────────────────────────────────
        navigation(startDestination = BottomNavItem.Recommend.root, route = BottomNavItem.Recommend.route) {
            composable(Screen.RECOMMEND) {
                RecommendScreen()
            }
        }

        // ── 탭 3: 규칙 판정관 ──────────────────────────────
        navigation(startDestination = BottomNavItem.RuleJudge.root, route = BottomNavItem.RuleJudge.route) {
            composable(Screen.RULE_JUDGE) {
                RuleJudgeScreen()
            }
        }

        // ── 탭 4: 전적 기록 ────────────────────────────────
        navigation(startDestination = BottomNavItem.History.root, route = BottomNavItem.History.route) {
            composable(Screen.SESSION_HISTORY) {
                SessionHistoryScreen { sessionId ->
                    navController.navigate(Screen.sessionDetail(sessionId))
                }
            }
            composable(
                Screen.SESSION_DETAIL,
                arguments = listOf(navArgument("sessionId") { type = NavType.LongType })
            ) {
                SessionDetailScreen(onNavigateBack = { navController.popBackStack() })
            }
        }

    }
}
