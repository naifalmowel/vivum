import 'package:flutter/material.dart';

class VivumColors {
  // Brand Colors (Constant)
  static const teal = Color(0xFF00B5CC);
  static const tealLight = Color(0xFF33C6D9);
  static const tealDark = Color(0xFF008FA3);
  static const amber = Color(0xFFF5A61A);
  static const amberLight = Color(0xFFF7B84B);

  // ─── Dark Theme: "Midnight Slate" — warmer & softer, not too black
  static const darkBG = Color(0xFF0F1117);      // رئيسي: أعمق بقليل لتباين أوضح
  static const darkSurface = Color(0xFF181B23); // كروت وسطح: دافئ أكثر
  static const darkCard = Color(0xFF1E2130);    // كروت داخلية: لون مائل للبنفسجي
  static const darkBorder = Color(0xFF2A2F3E);  // حدود: أوضح قليلاً
  static const darkMuted = Color(0xFFADB5D0);   // نص ثانوي: أفتح للقراءة
  static const darkWhite = Color(0xFFEEF0F5);   // نص رئيسي: أقرب للأبيض النقي

  // ─── Light Theme: "Warm Cloud" — كريمي دافئ بدلاً من البارد الجليدي
  static const lightBG = Color(0xFFF5F6FA);     // خلفية: دفء بدلاً من الأزرق
  static const lightBGAlt = Color(0xFFEBEDF5);  // خلفية بديلة
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFDDE0EE); // حدود: واضحة أكثر
  static const lightMuted = Color(0xFF5A6480);  // نص ثانوي: داكن للقراءة
  static const lightText = Color(0xFF0D1B2E);   // نص رئيسي: navy داكن

  static LinearGradient heroGradient(bool isDark) => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1117), Color(0xFF161A27), Color(0xFF0F1117)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F6FA), Color(0xFFEBEDF5), Color(0xFFF5F6FA)],
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
          colors: [Color(0xFF1E2130), Color(0xFF181B23)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F6FA)],
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
            shadow: Color(0xBB000000),
          )
        : const ColorScheme.light(
            primary: VivumColors.teal,
            secondary: VivumColors.amber,
            surface: VivumColors.lightSurface,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: VivumColors.lightText,
            outline: VivumColors.lightBorder,
            shadow: Color(0x1A0D1B2E),
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
          fontSize: 72, fontWeight: FontWeight.bold,
          color: textColor, height: 1.0, letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 56, fontWeight: FontWeight.bold,
          color: textColor, height: 1.1, letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 42, fontWeight: FontWeight.bold,
          color: textColor, height: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 36, fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal,
          color: mutedColor, height: 1.75,
        ),
        bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal,
          color: mutedColor, height: 1.65,
        ),
        bodySmall: TextStyle(
          fontSize: 13, fontWeight: FontWeight.normal,
          color: mutedColor, height: 1.6,
        ),
        labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold,
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
