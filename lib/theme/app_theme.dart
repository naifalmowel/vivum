import 'package:flutter/material.dart';

class VivumColors {
  // Brand Colors (Constant)
  static const teal = Color(0xFF00B5CC);
  static const tealLight = Color(0xFF33C6D9);
  static const tealDark = Color(0xFF008FA3);
  static const amber = Color(0xFFF5A61A);
  static const amberLight = Color(0xFFF7B84B);

  // Dark Theme Palette - Soft Slate Charcoal (More eye-friendly)
  static const darkBG = Color(0xFF15171E); 
  static const darkSurface = Color(0xFF1C1F26);
  static const darkCard = Color(0xFF232730);
  static const darkBorder = Color(0xFF2E333D);
  static const darkMuted = Color(0xFF9499B8);
  static const darkWhite = Color(0xFFE2E4E9); // Softened white text

  // Light Theme Palette - Professional Soft Icy Blue
  static const lightBG = Color(0xFFF0F4F8); 
  static const lightBGAlt = Color(0xFFE1E7EC); 
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFD9E2EC); 
  static const lightMuted = Color(0xFF627D98); 
  static const lightText = Color(0xFF102A43);

  static LinearGradient heroGradient(bool isDark) => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15171E), Color(0xFF1E2129), Color(0xFF15171E)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0F4F8), Color(0xFFD9E2EC), Color(0xFFF0F4F8)],
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
          colors: [Color(0xFF232730), Color(0xFF1C1F26)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF0F4F8)],
        );
}

class AppTheme {
  // Global font family - changed in one place
  static const String fontFamily = 'Cairo';

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
            shadow: Color(0x330F172A), // Increased shadow opacity (20%)
          );

    final textColor = isDark ? VivumColors.darkWhite : VivumColors.lightText;
    final mutedColor = isDark ? VivumColors.darkMuted : VivumColors.lightMuted;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: isDark ? VivumColors.darkBG : VivumColors.lightBG,
      colorScheme: colorScheme,
      dividerColor: colorScheme.outline,
      shadowColor: colorScheme.shadow,
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
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.dragged)) {
            return 8.0;
          }
          return 4.0;
        }),
        radius: const Radius.circular(10),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.dragged)) {
            return VivumColors.teal;
          }
          return VivumColors.teal.withValues(alpha: 0.15);
        }),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        minThumbLength: 60,
        interactive: true,
      ),
    );
  }
}
