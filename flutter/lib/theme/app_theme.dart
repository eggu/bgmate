import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── 서피스 변형 색상 ──────────────────────────────────────────────────────
  // Light: 따뜻한 토스트 아몬드  /  Dark: 심도감 있는 차콜
  static const Color _lightSurfaceVariant = Color(0xFFEFE7D4);
  static const Color _lightOnSurfaceVariant = Color(0xFF6B5E4A);

  static const Color _darkSurfaceVariant = Color(0xFF252830);
  static const Color _darkOnSurfaceVariant = Color(0xFF9E9585);

  // ── 라이트 컬러 스킴 ─────────────────────────────────────────────────────
  // 콘셉트: 양피지 크림 배경 위에 깊은 호박색 골드
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8B6800),         // 딥 앰버 — WCAG AA ~5.1:1
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFF0B8),// 골든 글로우 컨테이너
    onPrimaryContainer: Color(0xFF3D2D00),
    secondary: Color(0xFFB83226),       // 보드게임 레드
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDAD5),
    onSecondaryContainer: Color(0xFF7A1810),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFAF7F0),         // 따뜻한 양피지
    onSurface: Color(0xFF1A1410),       // 웜 니어-블랙
    outline: Color(0xFFCFC0A5),         // 웜 탠 테두리
    shadow: Colors.black,
    inverseSurface: Color(0xFF2E2A24),
    onInverseSurface: Color(0xFFF5EFE0),
    inversePrimary: Color(0xFFFFD54F),
    surfaceTint: Color(0xFF8B6800),
  );

  // ── 다크 컬러 스킴 ──────────────────────────────────────────────────────
  // 콘셉트: 딥 네이비-슬레이트 배경 위에 따뜻한 골드 강조
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFD54F),         // 워밍 골드
    onPrimary: Color(0xFF1A1410),
    primaryContainer: Color(0xFF3D2D00),
    onPrimaryContainer: Color(0xFFFFD54F),
    secondary: Color(0xFFFF7B78),
    onSecondary: Color(0xFF1A0A08),
    secondaryContainer: Color(0xFF4A100E),
    onSecondaryContainer: Color(0xFFFFAB8A),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    surface: Color(0xFF1C1E2A),         // 딥 네이비-슬레이트
    onSurface: Color(0xFFF0E8D8),       // 워밍 화이트
    outline: Color(0xFF3D3730),         // 웜 다크 테두리
    shadow: Colors.black,
    inverseSurface: Color(0xFFF0E8D8),
    onInverseSurface: Color(0xFF1C1E2A),
    inversePrimary: Color(0xFF6B5000),
    surfaceTint: Color(0xFFFFD54F),
  );

  // ── 타이포그래피 ─────────────────────────────────────────────────────────
  // Noto Serif KR (디스플레이/헤드라인) + Noto Sans KR (바디/레이블)
  // 캐싱: light()/dark() 호출마다 GoogleFonts 객체를 재생성하지 않도록 지연 초기화
  static TextTheme? _cachedLightTextTheme;
  static TextTheme? _cachedDarkTextTheme;

  static TextTheme _getTextTheme({required Brightness brightness}) {
    if (brightness == Brightness.light) {
      return _cachedLightTextTheme ??=
          _buildTextTheme(brightness: Brightness.light);
    } else {
      return _cachedDarkTextTheme ??=
          _buildTextTheme(brightness: Brightness.dark);
    }
  }

  static TextTheme _buildTextTheme({required Brightness brightness}) {
    final Color text = brightness == Brightness.light
        ? const Color(0xFF1A1410)
        : const Color(0xFFF0E8D8);
    final Color muted = brightness == Brightness.light
        ? const Color(0xFF6B5E4A)
        : const Color(0xFF9E9585);

    return TextTheme(
      // 디스플레이 — Noto Serif KR (편집지면 감성)
      displayLarge:  GoogleFonts.notoSerifKr(fontSize: 57, fontWeight: FontWeight.w400, color: text),
      displayMedium: GoogleFonts.notoSerifKr(fontSize: 45, fontWeight: FontWeight.w400, color: text),
      displaySmall:  GoogleFonts.notoSerifKr(fontSize: 36, fontWeight: FontWeight.w400, color: text),
      headlineLarge: GoogleFonts.notoSerifKr(fontSize: 32, fontWeight: FontWeight.w700, color: text),
      headlineMedium:GoogleFonts.notoSerifKr(fontSize: 28, fontWeight: FontWeight.w600, color: text),
      headlineSmall: GoogleFonts.notoSerifKr(fontSize: 24, fontWeight: FontWeight.w600, color: text),
      titleLarge:    GoogleFonts.notoSerifKr(fontSize: 20, fontWeight: FontWeight.w600, color: text),
      // UI 텍스트 — Noto Sans KR (가독성 최우선)
      titleMedium:   GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w600, color: text, letterSpacing: 0.15),
      titleSmall:    GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w600, color: text, letterSpacing: 0.1),
      bodyLarge:     GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w400, color: text),
      bodyMedium:    GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w400, color: text),
      bodySmall:     GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w400, color: muted),
      labelLarge:    GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w600, color: text, letterSpacing: 0.1),
      labelMedium:   GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w500, color: text, letterSpacing: 0.5),
      labelSmall:    GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w500, color: muted, letterSpacing: 0.5),
    );
  }

  // ── 라이트 테마 ──────────────────────────────────────────────────────────
  static ThemeData light() {
    const cs = _lightColorScheme;
    final tt = _getTextTheme(brightness: Brightness.light);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: tt,
      scaffoldBackgroundColor: cs.surface,
      canvasColor: cs.surface,
      dividerColor: cs.outline,
      cardColor: _lightSurfaceVariant,

      // 앱바: 서피스 배경 + Noto Serif KR 타이틀
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSerifKr(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),

      // 카드: 웜 크림 배경, 테두리 없음, 둥근 모서리
      cardTheme: const CardThemeData(
        color: _lightSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.zero,
      ),

      // 칩: 웜 크림 기본, 골든 선택 상태
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF2EBD9),
        selectedColor: cs.primaryContainer,
        disabledColor: const Color(0xFFEDE5D2),
        labelStyle: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
        secondaryLabelStyle: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.onPrimaryContainer,
        ),
        side: const BorderSide(color: Color(0xFFCFC0A5)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // 입력 필드: 웜 크림 배경, 골드 포커스 테두리
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCFC0A5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCFC0A5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF8B6800), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F0E5),
        labelStyle: GoogleFonts.notoSansKr(
          fontSize: 14,
          color: const Color(0xFF6B5E4A),
        ),
        hintStyle: GoogleFonts.notoSansKr(
          fontSize: 14,
          color: const Color(0xFFA89070),
        ),
        helperStyle: GoogleFonts.notoSansKr(
          fontSize: 12,
          color: const Color(0xFF6B5E4A),
        ),
      ),

      // 네비게이션 바
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.notoSansKr(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? cs.primary : const Color(0xFF6B5E4A),
          );
        }),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cs.primary,
        selectionColor: cs.primary.withValues(alpha: 0.25),
        selectionHandleColor: cs.primary,
      ),
    );
  }

  // ── 다크 테마 ────────────────────────────────────────────────────────────
  static ThemeData dark() {
    const cs = _darkColorScheme;
    final tt = _getTextTheme(brightness: Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: tt,
      scaffoldBackgroundColor: cs.surface,
      canvasColor: cs.surface,
      dividerColor: cs.outline,
      cardColor: _darkSurfaceVariant,

      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSerifKr(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),

      cardTheme: const CardThemeData(
        color: _darkSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.zero,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2D3A),
        selectedColor: cs.primaryContainer,
        disabledColor: const Color(0xFF232530),
        labelStyle: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
        secondaryLabelStyle: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.onPrimaryContainer,
        ),
        side: const BorderSide(color: Color(0xFF3D3730)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3D3730)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3D3730)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFFD54F), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF22253A),
        labelStyle: GoogleFonts.notoSansKr(
          fontSize: 14,
          color: const Color(0xFF9E9585),
        ),
        hintStyle: GoogleFonts.notoSansKr(
          fontSize: 14,
          color: const Color(0xFF7A7265),
        ),
        helperStyle: GoogleFonts.notoSansKr(
          fontSize: 12,
          color: const Color(0xFF9E9585),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.notoSansKr(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? cs.primary : const Color(0xFF9E9585),
          );
        }),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cs.primary,
        selectionColor: cs.primary.withValues(alpha: 0.25),
        selectionHandleColor: cs.primary,
      ),
    );
  }

  // ── 퍼블릭 헬퍼 ─────────────────────────────────────────────────────────
  static Color lightSurfaceVariant(BuildContext context) => _lightSurfaceVariant;
  static Color lightOnSurfaceVariant(BuildContext context) => _lightOnSurfaceVariant;
  static Color darkSurfaceVariant(BuildContext context) => _darkSurfaceVariant;
  static Color darkOnSurfaceVariant(BuildContext context) => _darkOnSurfaceVariant;

  /// Surface 위에서 primary 계열 색상으로 텍스트를 표시할 때 사용.
  /// AAA 수준 대비를 보장하는 onPrimaryContainer 색상 반환.
  static Color primaryText(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimaryContainer;
}
