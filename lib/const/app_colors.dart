import 'package:flutter/material.dart';

class AppColors {

  /// 🔥 Primary Colors (الأساسية)
  static const Color primary = Color(0xFFA467A7);
  static const Color secondary = Color(0xFFC28DBD);
  static const Color light = Color(0xFFDBB9D7);
  static const Color background = Color(0xFFF5EFE7);
  /// 🌸 إضافي خفيف (للزر اللي عندك)
  static const Color accent = Color(0xFFC9A9FF);

  /// 🤍 ألوان عامة
  static const Color white = Colors.white;
  static const Color transparentWhite = Color(0x26FFFFFF); // 15% opacity

  /// 🔤 Text
  static const Color textWhite = Colors.white;
  static const Color textLight = Colors.white70;
  static const Color textDark = Color(0xFF2E2E2E);

  /// 🔥 Gradient كامل للتطبيق
  static const List<Color> mainGradient = [
    primary,
    secondary,
    light,
  ];

  /// 🔥 Gradient للأزرار
  static const List<Color> buttonGradient = [
    primary,
    accent,
  ];

  /// ✨ Glass effect
  static Color glass = Colors.white.withOpacity(0.15);
  static Color glassBorder = Colors.white.withOpacity(0.2);

  /// 🌫️ Blur circles
  static Color blur = Colors.white.withOpacity(0.2);
}