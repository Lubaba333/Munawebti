import 'package:flutter/material.dart';
import '../../../utlis/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onEmergencyTap; // 🔥 زر الطوارئ

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onEmergencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            /// 📅 محاضراتي
            _buildNavItem(0, Icons.calendar_month, "محاضراتي"),

            /// 🚨 زر الطوارئ (🔥 جديد)
            GestureDetector(
              onTap: onEmergencyTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "طوارئ",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            /// 🏠 الرئيسية
            GestureDetector(
              onTap: () => onTap(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.mainGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkPurple.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    "الرئيسية",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: currentIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentIndex == 1
                          ? AppColors.darkPurple
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            /// 📝 طلباتي
            _buildNavItem(2, Icons.request_page, "طلباتي"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.darkPurple : Colors.grey.shade500,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.darkPurple : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}