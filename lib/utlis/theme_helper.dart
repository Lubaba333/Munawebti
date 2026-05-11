import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeHelper {
  // ✅ خلفية مناسبة للوضعين
  static Color scaffoldBg(BuildContext context) => 
      Theme.of(context).scaffoldBackgroundColor;

  // ✅ لون بطاقة متوازن
  static Color cardBg(BuildContext context) => 
      Theme.of(context).cardColor;

  // ✅ نص رئيسي واضح
  static TextStyle mainText(BuildContext context) => 
      Theme.of(context).textTheme.bodyLarge!;

  // ✅ نص ثانوي مقروء
  static TextStyle subText(BuildContext context) => 
      Theme.of(context).textTheme.bodyMedium!;

  // ✅ تدرج ذكي للخلفيات (يخفف حدة الألوان في الدارك)
  static List<Color> smartGradient(Color start, Color end) {
    return Get.isDarkMode 
        ? [start.withOpacity(0.75), end.withOpacity(0.6)]
        : [start, end];
  }
}