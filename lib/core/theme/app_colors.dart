import 'package:flutter/material.dart';

/// Central color palette for AutoCare Pro.
/// Every screen should reference these constants instead of
/// hardcoding hex colors, so the theme stays consistent everywhere.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color inputFill = Color(0xFF262626);

  // Accents
  static const Color limeAccent = Color(0xFFD4FF3F);
  static const Color amberAccent = Color(0xFFFFC24B);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textMuted = Color(0xFF6B6B6B);

  // Status colors
  static const Color statusSuccess = Color(0xFF4CD964);
  static const Color statusPending = Color(0xFFFFC24B);
  static const Color statusError = Color(0xFFFF5A5F);
  static const Color statusNeutral = Color(0xFF7A7A7A);

  // Dividers
  static const Color divider = Color(0x1AFFFFFF); // 10% white
}