package com.kurt.bgmate.presentation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AutoAwesome
import androidx.compose.material.icons.outlined.EmojiEvents
import androidx.compose.material.icons.outlined.Gavel
import androidx.compose.material.icons.outlined.Inventory2
import androidx.compose.ui.graphics.vector.ImageVector

enum class BottomNavItem(
    val route: String,
    val label: String,
    val root: String,
    val icon: ImageVector
) {
    Collection(
        route = "tab_collection",
        label = "컬렉션",
        root = Screen.GAME_LIST,
        icon = Icons.Outlined.Inventory2
    ),
    Recommend(
        route = "tab_recommend",
        label = "게임 추천",
        root = Screen.RECOMMEND,
        icon = Icons.Outlined.AutoAwesome
    ),
    RuleJudge(
        route = "tab_rule_judge",
        label = "규칙 판정관",
        root = Screen.RULE_JUDGE,
        icon = Icons.Outlined.Gavel
    ),
    History(
        route = "tab_history",
        label = "전적 기록",
        root = Screen.SESSION_HISTORY,
        icon = Icons.Outlined.EmojiEvents
    )
}
