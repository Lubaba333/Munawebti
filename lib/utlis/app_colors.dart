// lib/core/colors/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية من الصورة
  static const Color softLavender = Color(0xFFF1E2EE);  // أفتح لون
  static const Color lightPink = Color(0xFFDBB9D7);
  static const Color mauve = Color(0xFFC28DBD);
  static const Color deepPurple = Color(0xFFA467A7);
  static const Color darkPurple = Color(0xFF904B99);   // الأغمق
  
  // ألوان إضافية
  static const Color white = Colors.white;
  static const Color black = Color(0xFF2D2D2D);
  static const Color hintGray = Color(0xFF9E9E9E);
  
  // التدرج الرئيسي (مثل الصورة)
  static const LinearGradient mainGradient = LinearGradient(
    colors: [
      Color(0xFFF1E2EE),  // فاتح
      Color(0xFFC28DBD),  // متوسط
      Color(0xFF904B99),  // غامق
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // تدرج ثانوي للخلفية
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFF1E2EE),
      Color(0xFFDBB9D7),
      Color(0xFFC28DBD),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}