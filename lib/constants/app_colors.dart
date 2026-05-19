import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF7C3AED);
  static const primaryDark = Color(0xFF6D28D9);
  static const correctGreen = Color(0xFF22C55E);
  static const success = correctGreen;
  static const wrongRed = Color(0xFFEF4444);
  static const error = wrongRed;
  static const background = Color(0xFFF9FAFB);
  static const cardWhite = Color(0xFFFFFFFF);
  static const card = cardWhite;
  static const textDark = Color(0xFF111827);
  static const textPrimary = textDark;
  static const textSecondary = Color(0xFF6B7280);
  static const optionBorderDefault = Color(0xFFE5E7EB);
  static const border = optionBorderDefault;
  static const optionBorderSelected = primary;
  static const optionBgSelected = Color(0xFFEDE9FE);
  static const optionBorderCorrect = correctGreen;
  static const optionBgCorrect = Color(0xFFDCFCE7);
  static const optionBorderWrong = wrongRed;
  static const optionBgWrong = Color(0xFFFEE2E2);
  static const buttonDisabled = Color(0xFFD1D5DB);
  static const buttonDisabledText = Color(0xFF9CA3AF);
  static const disabled = buttonDisabled;
  static const successLight = optionBgCorrect;
  static const errorLight = optionBgWrong;
  static const gold = Color(0xFFF59E0B);

  // Existing app aliases kept on the enforced lesson design system.
  static const palm = primary;
  static const palmDark = primaryDark;
  static const date = gold;
  static const sand = background;
  static const cream = cardWhite;
  static const ink = textDark;
  static const muted = textSecondary;
  static const danger = wrongRed;
}
