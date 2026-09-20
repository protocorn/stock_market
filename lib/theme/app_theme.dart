import 'package:flutter/material.dart';

/// Shared brand colors and layout tokens used across every tab.
class AppColors {
  static const Color background = Color(0xFFF5F7F5);
  static const Color primary = Color(0xFF1B5E3B);
  static const Color surface = Colors.white;
  static const Color softGreen = Color(0xFFF0F4F1);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Color(0xFF607D8B);
  static const Color border = Color(0xFFE0E0E0);
  static const Color scoreLow = Color(0xFFC62828);
  static const Color scoreMid = Color(0xFFC9A227);
  static const Color scoreHigh = Color(0xFF1B5E3B);
  static const Color negative = Color(0xFFC62828);

  static Color scoreColor(int score) {
    if (score >= 70) return scoreHigh;
    if (score >= 40) return scoreMid;
    return scoreLow;
  }
}

class AppLayout {
  static const double wideBreakpoint = 800;
  static const double contentMaxWidth = 720;
  static const double pagePaddingWide = 32;
  static const double pagePaddingNarrow = 16;
  static const double searchTopPadding = 12;
  static const double sectionGap = 16;
  static const double radiusCard = 16;
  static const double radiusSearch = 28;
}

ThemeData buildAppTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    surface: AppColors.background,
  );

  return ThemeData(
    colorScheme: base.copyWith(
      primary: AppColors.primary,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusSearch),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusSearch),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusSearch),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}
