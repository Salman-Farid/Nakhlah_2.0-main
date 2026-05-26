import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Sandy Yellow / Warm Gold (website primary)
  static const primary = Color(0xFFE8D5B7);
  static const primaryDark = Color(0xFFD4BC96);

  // Accent — Violet (website accent / button color)
  static const accent = Color(0xFF7C3AED);

  // Greens — Palm theme
  static const palm = Color(0xFF4A7A5A);
  static const palmDark = Color(0xFF3D6349);

  // Premium Gradient — Purple/Violet
  static const premiumGradientStart = Color(0xFF7B3FE4);
  static const premiumGradientEnd = Color(0xFF8E4EF2);
  static const correctGreen = Color(0xFF22C55E);
  static const success = correctGreen;

  // Destructive / Error
  static const destructive = Color(0xFFDC2626);
  static const wrongRed = Color(0xFFEF4444);
  static const error = wrongRed;

  // Backgrounds
  static const background = Color(0xFFF5F0E8); // Warm Cream
  static const cardWhite = Color(0xFFFBF8F3);
  static const card = cardWhite;

  // Text
  static const textDark = Color(0xFF2E2318); // Dark foreground
  static const textPrimary = textDark;
  static const textSecondary = Color(0xFF8A7A6B); // Muted

  // Borders
  static const optionBorderDefault = Color(0xFFDDD3C4);
  static const border = optionBorderDefault;
  static const optionBorderSelected = accent;
  static const optionBgSelected = Color(0xFFEDE9FE);
  static const optionBorderCorrect = correctGreen;
  static const optionBgCorrect = Color(0xFFDCFCE7);
  static const optionBorderWrong = wrongRed;
  static const optionBgWrong = Color(0xFFFEE2E2);

  // Buttons
  static const buttonDisabled = Color(0xFFD1D5DB);
  static const buttonDisabledText = Color(0xFF9CA3AF);
  static const disabled = buttonDisabled;

  // Feedback lights
  static const successLight = optionBgCorrect;
  static const errorLight = optionBgWrong;

  // Gold / Date
  static const gold = Color(0xFFF59E0B);
  static const date = gold;

  // Section accent colors (matching website)
  static const sectionGreen = Color(0xFF10B981);
  static const sectionPurple = Color(0xFF7C3AED);
  static const sectionOrange = Color(0xFFF97316);

  // Semantic aliases (used throughout the app)
  static const sand = background;
  static const cream = cardWhite;
  static const ink = textDark;
  static const muted = textSecondary;
  static const danger = wrongRed;
}
