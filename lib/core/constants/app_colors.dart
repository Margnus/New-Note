import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F7);
  static const Color lightPrimary = Color(0xFF007AFF);
  static const Color lightPrimaryDark = Color(0xFF0056B3);
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF8E8E93);
  static const Color lightDivider = Color(0xFFE5E5EA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardShadow = Color(0x1A000000);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkPrimary = Color(0xFF0A84FF);
  static const Color darkPrimaryDark = Color(0xFF409CFF);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF98989D);
  static const Color darkDivider = Color(0xFF38383A);
  static const Color darkCard = Color(0xFF1C1C1E);
  static const Color darkCardShadow = Color(0x33FFFFFF);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF5AC8FA);

  // Tag Colors
  static const List<Color> tagColors = [
    Color(0xFFFF3B30), // Red
    Color(0xFFFF9500), // Orange
    Color(0xFFFFCC00), // Yellow
    Color(0xFF34C759), // Green
    Color(0xFF5AC8FA), // Blue
    Color(0xFF007AFF), // Light Blue
    Color(0xFF5856D6), // Purple
    Color(0xFFAF52DE), // Pink
  ];
}
