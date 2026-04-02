package com.kurt.bgmate.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

private val LightColorScheme = lightColorScheme(
    primary              = BgPrimary,
    onPrimary            = BgOnPrimary,
    primaryContainer     = BgPrimaryContainer,
    onPrimaryContainer   = BgOnPrimaryContainer,
    secondary            = BgSecondary,
    onSecondary          = BgOnSecondary,
    secondaryContainer   = BgSecondaryContainer,
    onSecondaryContainer = BgOnSecondaryContainer,
    surface              = BgSurface,
    surfaceVariant       = BgSurfaceVariant,
    onSurface            = BgOnSurface,
    onSurfaceVariant     = BgOnSurfaceVariant,
    outline              = BgOutline,
)

private val DarkColorScheme = darkColorScheme(
    primary              = BgPrimaryDark,
    onPrimary            = BgOnPrimaryDark,
    primaryContainer     = BgPrimaryContainerDark,
    onPrimaryContainer   = BgOnPrimaryContainerDark,
    secondary            = BgSecondaryDark,
    onSecondary          = BgOnSecondaryDark,
    secondaryContainer   = BgSecondaryContainerDark,
    onSecondaryContainer = BgOnSecondaryContainerDark,
    surface              = BgSurfaceDark,
    surfaceVariant       = BgSurfaceVariantDark,
    onSurface            = BgOnSurfaceDark,
    onSurfaceVariant     = BgOnSurfaceVariantDark,
    outline              = BgOutlineDark,
)

@Composable
fun BGMateTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    MaterialTheme(
        colorScheme = colorScheme,
        typography  = Typography,
        content     = content
    )
}