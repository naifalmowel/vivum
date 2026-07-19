import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VivumColors {
  // Brand Colors (Constant)
  static const teal = Color(0xFF00B5CC);
  static const tealLight = Color(0xFF33C6D9);
  static const tealDark = Color(0xFF008FA3);
  static const amber = Color(0xFFF5A61A);
  static const amberLight = Color(0xFFF7B84B);

  // Dark Theme Palette
  static const darkBG = Color(0xFF07091A);
  static const darkSurface = Color(0xFF0F1226);
  static const darkCard = Color(0xFF12152E);
  static const darkBorder = Color(0xFF1E2145);
  static const darkMuted = Color(0xFF8B90B0);
  static const darkWhite = Color(0xFFF8F9FC);

  // Light Theme Palette
  static const lightBG = Color(0xFFF8FAFF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightMuted = Color(0xFF64748B);
  static const lightText = Color(0xFF0F172A);

  static LinearGradient heroGradient(bool isDark) => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07091A), Color(0xFF0D1035), Color(0xFF07091A)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FAFF), Color(0xFFE2E8FF), Color(0xFFF8FAFF)],
        );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [teal, Color(0xFF006B7A)],
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [amber, Color(0xFFE8890A)],
  );

  static LinearGradient cardGradient(bool isDark) => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141730), Color(0xFF0F1228)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
        );
}

class AppTheme {
  // "Plus Jakarta Sans" provides a very modern, professional, tech-forward feel
  // "Manrope" is another excellent alternative.
  static final String _fontFamily = GoogleFonts.plusJakartaSans().fontFamily!;

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme colorScheme = isDark
        ? const ColorScheme.dark(
            primary: VivumColors.teal,
            secondary: VivumColors.amber,
            surface: VivumColors.darkSurface,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: VivumColors.darkWhite,
            outline: VivumColors.darkBorder,
            shadow: Colors.black,
          )
        : const ColorScheme.light(
            primary: VivumColors.teal,
            secondary: VivumColors.amber,
            surface: VivumColors.lightSurface,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: VivumColors.lightText,
            outline: VivumColors.lightBorder,
            shadow: Color(0x1A0F172A),
          );

    final textColor = isDark ? VivumColors.darkWhite : VivumColors.lightText;
    final mutedColor = isDark ? VivumColors.darkMuted : VivumColors.lightMuted;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: isDark ? VivumColors.darkBG : VivumColors.lightBG,
      colorScheme: colorScheme,
      dividerColor: colorScheme.outline,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 72, fontWeight: FontWeight.w800,
          color: textColor, height: 1.0, letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 56, fontWeight: FontWeight.w800,
          color: textColor, height: 1.1, letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 42, fontWeight: FontWeight.w700,
          color: textColor, height: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 36, fontWeight: FontWeight.w700,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400,
          color: mutedColor, height: 1.7,
        ),
        bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: mutedColor, height: 1.6,
        ),
        labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: textColor, letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? VivumColors.darkCard : VivumColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
    );
  }
}
