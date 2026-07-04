import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/utlis/theme_helper.dart';

class ThemeToggle extends StatelessWidget {
  ThemeToggle({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.20)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeInOut,
  alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
  child: Container(
    width: (MediaQuery.sizeOf(context).width - 32) / 2,
    height: 46,
    margin: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.28),
      borderRadius: BorderRadius.circular(14),
    ),
  ),
),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => themeController.setTheme(false),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.light_mode,
                            size: 18,
                            color: !isDark ? Colors.amber : Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "الوضع الفاتح",
                            style: TextStyle(
                              color: !isDark ? Colors.amber : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => themeController.setTheme(true),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dark_mode,
                            size: 18,
                            color: isDark
                                ? const Color(0xFFD9B5D5)
                                : Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "الوضع الداكن",
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFFD9B5D5)
                                  : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}