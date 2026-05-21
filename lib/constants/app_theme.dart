import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double buttonHeight = 56;
  static const double buttonRadius = 16; // rounded-2xl
  static const double cardRadius = 16; // rounded-2xl
  static const double largeRadius = 24; // rounded-3xl
  static const EdgeInsets bottomActionPadding = EdgeInsets.all(16);
  static const String fontFamily = 'Inter';
  static const String arabicFontFamily = 'Amiri';

  static TextStyle arabicTextStyle({
    double fontSize = 34,
    FontWeight fontWeight = FontWeight.w900,
    Color color = AppColors.textPrimary,
  }) => TextStyle(
    fontFamily: arabicFontFamily,
    fontFamilyFallback: const ['Scheherazade New', 'Noto Sans Arabic'],
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: 1.25,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary, // Sandy Yellow
      secondary: AppColors.palm, // Palm Green
      tertiary: AppColors.accent, // Violet
      error: AppColors.error,
      surface: AppColors.card,
      onPrimary: AppColors.ink,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onError: Colors.white,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.buttonDisabled,
        disabledForegroundColor: AppColors.buttonDisabledText,
        minimumSize: const Size.fromHeight(buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily,
        ),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
    ),
  );
}
