import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  void _toggle() {
    Get.changeThemeMode(
      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [

            Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                Get.isDarkMode ? "الوضع الداكن" : "الوضع الفاتح",
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}