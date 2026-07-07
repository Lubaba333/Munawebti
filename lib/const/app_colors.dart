import 'package:flutter/material.dart';

class AppColors {

  static const Color primary = Color(0xFFA467A7);
  static const Color secondary = Color(0xFFC28DBD);
  static const Color light = Color(0xFFDBB9D7);
  static const Color accent = Color(0xFFC9A9FF);

  /// 🌤️ Light Mode
  // static const Color backgroundLight = Color(0xFFF5EFE7);xFFFAF9FC
  static const Color backgroundLight = Color(0xFFF7F7FA);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF2E2E2E);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);

  /// 🌙 Dark Mode
  static const Color backgroundDark = Color(0xFF1C1620);
  static const Color surfaceDark = Color(0xFF2A2130);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;

  ///  ألوان عامة
  static const Color white = Colors.white;
  static const Color transparentWhite = Color(0x26FFFFFF); // 15% opacity


  static const Color background = backgroundLight;
  static const Color textDark = textPrimaryLight;
  static const Color textLight = Colors.white70;
  static const Color textWhite = Colors.white;

  ///  Gradient كامل للتطبيق
  static const List<Color> mainGradient = [primary, secondary, light];

  ///  Gradient للأزرار
  static const List<Color> buttonGradient = [primary, accent];

  ///  Glass effect
  static Color glass = Colors.white.withOpacity(0.15);
  static Color glassBorder = Colors.white.withOpacity(0.2);

  ///  Blur circles
  static Color blur = Colors.white.withOpacity(0.2);
}
