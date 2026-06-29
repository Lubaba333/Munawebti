import 'package:flutter/material.dart';
import '../../../utlis/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(4, Icons.settings, "إعدادات", Colors.grey),
            _buildNavItem(0, Icons.calendar_month, "محاضراتي", Colors.grey),

            GestureDetector(
              onTap: () => onTap(1),
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkPurple.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),

            _buildNavItem(2, Icons.request_page, "طلباتي", Colors.grey),
            _buildNavItem(3, Icons.sos, "طوارئ", Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color iconColor) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.softLavender.withOpacity(0.6)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (iconColor == Colors.red ? Colors.red : AppColors.darkPurple)
                  : iconColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (iconColor == Colors.red ? Colors.red : AppColors.darkPurple)
                    : iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}