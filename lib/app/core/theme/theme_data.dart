import 'package:flutter/material.dart';

class AppThemeColors {
  AppThemeColors._();

  static const Color darkBackground = Color(0xFF091420);
  static const Color darkSurface = Color(0xFF15202C);
  static const Color darkSurfaceVariant = Color(0xFF202B37);
  static const Color darkPrimary = Color(0xFF86CFFF);
  static const Color darkPrimaryContainer = Color(0xFF24A1DE);
  static const Color darkOnSurface = Color(0xFFD8E3F4);
  static const Color darkOnSurfaceVariant = Color(0xFFBEC8D1);

  static const Color lightBackground = Color(0xFFF2F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFE7EEF5);
  static const Color lightPrimary = Color(0xFFD8E3F4);
  static const Color lightPrimaryContainer = Color(0xFFBFE5FF);
  static const Color lightOnSurface = Color(0xFF1B2733);
  static const Color lightOnSurfaceVariant = Color(0xFF4E5C69);
}

class AppThemeData {
  AppThemeData._();

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppThemeColors.darkPrimary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppThemeColors.darkPrimary,
      secondary: const Color(0xFFA7CBE6),
      surface: AppThemeColors.darkSurface,
      onSurface: AppThemeColors.darkOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppThemeColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppThemeColors.darkSurface.withValues(alpha: 0.95),
        foregroundColor: AppThemeColors.darkOnSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppThemeColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppThemeColors.darkSurfaceVariant,
        selectedColor: AppThemeColors.darkPrimary.withValues(alpha: 0.2),
        labelStyle: const TextStyle(color: AppThemeColors.darkOnSurfaceVariant),
        secondaryLabelStyle: const TextStyle(color: AppThemeColors.darkPrimary),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppThemeColors.darkOnSurfaceVariant,
        textColor: AppThemeColors.darkOnSurface,
      ),
    );
  }

  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppThemeColors.lightPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppThemeColors.lightPrimary,
      secondary: const Color(0xFF4A7E9E),
      surface: AppThemeColors.lightSurface,
      onSurface: AppThemeColors.lightOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppThemeColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeColors.lightSurface,
        foregroundColor: AppThemeColors.lightOnSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppThemeColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppThemeColors.lightSurfaceVariant,
        selectedColor: AppThemeColors.lightPrimary.withValues(alpha: 0.16),
        labelStyle: const TextStyle(
          color: AppThemeColors.lightOnSurfaceVariant,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppThemeColors.lightPrimary,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppThemeColors.lightOnSurfaceVariant,
        textColor: AppThemeColors.lightOnSurface,
      ),
    );
  }
}
