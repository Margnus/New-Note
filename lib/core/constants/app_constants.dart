import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // App
  static const String appTitle = 'KPM';
  static const String appVersion = '1.0.0';

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double iconSize = 24.0;

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Storage
  static const String databaseName = 'kpm.db';
  static const String hiveBox = 'kpm_box';

  // Editor
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;
  static const double defaultFontSize = 16.0;

  // Search
  static const int searchDebounceMs = 500;

  // Pagination
  static const int pageSize = 20;

  // Cache
  static const int cacheMaxAgeDays = 7;
}
