import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.primary,
      onPrimary: Colors.white,
      secondary: AppPalette.secondary,
      onSecondary: Colors.white,
      error: Color(0xFFB91C1C),
      onError: Colors.white,
      surface: AppPalette.surface,
      onSurface: AppPalette.textStrong,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppPalette.background,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppPalette.textStrong,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppPalette.textStrong,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppPalette.textStrong,
        ),
        bodyMedium: TextStyle(color: AppPalette.textStrong),
        bodySmall: TextStyle(color: AppPalette.textMuted),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.textStrong,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppPalette.textStrong,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppPalette.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD0DCE1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.primary, width: 1.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFDCEEEF),
        selectedColor: const Color(0xFFBFDFE0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF14B8A6),
        secondary: const Color(0xFFFB923C),
      ),
      scaffoldBackgroundColor: const Color(0xFF0B1220),
    );
  }
}
