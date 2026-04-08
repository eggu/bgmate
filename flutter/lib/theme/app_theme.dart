import 'package:flutter/material.dart';

class AppTheme {
  static const Color _lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color _lightOnSurfaceVariant = Color(0xFF757575);

  static const Color _darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color _darkOnSurfaceVariant = Color(0xFF9E9E9E);

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFFD600),
    onPrimary: Color(0xFF7A6400),
    primaryContainer: Color(0xFFFFECB3),
    onPrimaryContainer: Color(0xFF5C4A00),
    secondary: Color(0xFFE53935),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFCDD2),
    onSecondaryContainer: Color(0xFFB71C1C),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFAFAFA),
    onSurface: Color(0xFF212121),
    outline: Color(0xFFE0E0E0),
    shadow: Colors.black,
    inverseSurface: Color(0xFF2F2F2F),
    onInverseSurface: Color(0xFFF5F5F5),
    inversePrimary: Color(0xFFFFE566),
    surfaceTint: Color(0xFFFFD600),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFE566),
    onPrimary: Color(0xFF1A1A1A),
    primaryContainer: Color(0xFF4A3B00),
    onPrimaryContainer: Color(0xFFFFE566),
    secondary: Color(0xFFFF6B68),
    onSecondary: Color(0xFF1A1A1A),
    secondaryContainer: Color(0xFF5C1010),
    onSecondaryContainer: Color(0xFFFFAB40),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFEEEEEE),
    outline: Color(0xFF3A3A3A),
    shadow: Colors.black,
    inverseSurface: Color(0xFFEAEAEA),
    onInverseSurface: Color(0xFF1E1E1E),
    inversePrimary: Color(0xFF7A6400),
    surfaceTint: Color(0xFFFFE566),
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: _lightColorScheme.surface,
      canvasColor: _lightColorScheme.surface,
      dividerColor: _lightColorScheme.outline,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.surface,
        foregroundColor: _lightColorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: _lightSurfaceVariant,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _lightColorScheme.primary,
        selectionColor: _lightColorScheme.primary.withValues(alpha: 0.25),
        selectionHandleColor: _lightColorScheme.primary,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _darkColorScheme.surface,
      canvasColor: _darkColorScheme.surface,
      dividerColor: _darkColorScheme.outline,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.surface,
        foregroundColor: _darkColorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: _darkSurfaceVariant,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _darkColorScheme.primary,
        selectionColor: _darkColorScheme.primary.withValues(alpha: 0.25),
        selectionHandleColor: _darkColorScheme.primary,
      ),
    );
  }

  static Color lightSurfaceVariant(BuildContext context) => _lightSurfaceVariant;

  static Color lightOnSurfaceVariant(BuildContext context) =>
      _lightOnSurfaceVariant;

  static Color darkSurfaceVariant(BuildContext context) => _darkSurfaceVariant;

  static Color darkOnSurfaceVariant(BuildContext context) =>
      _darkOnSurfaceVariant;
}
