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

  // ========== تدرجات الكرات ثلاثية الأبعاد ==========
  
  // كرة 1 - كبيرة
  static const LinearGradient sphere1Gradient = LinearGradient(
    colors: [
      Color(0xFFE8D5E5),  // لمعة علوية
      Color(0xFFC28DBD),  // اللون الرئيسي
      Color(0xFF904B99),  // الظل
      Color(0xFF6B3A73),  // ظل أعمق
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // كرة 2 - متوسطة
  static const LinearGradient sphere2Gradient = LinearGradient(
    colors: [
      Color(0xFFF0E0ED),
      Color(0xFFD4A5D0),
      Color(0xFFA467A7),
      Color(0xFF7B4B80),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // كرة 3 - صغيرة
  static const LinearGradient sphere3Gradient = LinearGradient(
    colors: [
      Color(0xFFEBD8E8),
      Color(0xFFC794C3),
      Color(0xFF9B5FA3),
      Color(0xFF734578),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // كرة 4 - متوسطة سفلية
  static const LinearGradient sphere4Gradient = LinearGradient(
    colors: [
      Color(0xFFE5D0E3),
      Color(0xFFB880B5),
      Color(0xFF8B4B90),
      Color(0xFF66366B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // كرة 5 - صغيرة علوية
  static const LinearGradient sphere5Gradient = LinearGradient(
    colors: [
      Color(0xFFF3E7F0),
      Color(0xFFD9B5D5),
      Color(0xFFAA72AD),
      Color(0xFF825285),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // قائمة تدرجات الكرات
  static List<LinearGradient> get allSphereGradients => [
    sphere1Gradient,
    sphere2Gradient,
    sphere3Gradient,
    sphere4Gradient,
    sphere5Gradient,
  ];
}