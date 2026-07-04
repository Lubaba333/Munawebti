import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final isDark = Get.isDarkMode;

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).cardColor.withOpacity(.92)
            : Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? AppColors.mauve.withOpacity(.18)
              : Colors.white.withOpacity(.35),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.30)
                : Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Row(
          children: [
            Expanded(
              child: _buildNavItem(
                context,
                4,
                Icons.settings,
                "settings".tr,
                Colors.grey,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                0,
                Icons.calendar_month,
                "my_lectures".tr,
                Colors.grey,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(1),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? AppColors.darkMainGradient
                        : AppColors.mainGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(.30)
                            : AppColors.darkPurple.withOpacity(0.30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                2,
                Icons.request_page,
                "my_requests".tr,
                Colors.grey,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                3,
                Icons.sos,
                "emergency".tr,
                Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    Color iconColor,
  ) {
    final isSelected = currentIndex == index;
    final isDark = Get.isDarkMode;

    final selectedColor =
        iconColor == Colors.red ? Colors.red : AppColors.mauve;

    final unselectedColor = isDark ? Colors.white60 : iconColor;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.mauve.withOpacity(.14)
                  : AppColors.softLavender.withOpacity(0.60))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected && isDark
              ? Border.all(color: AppColors.mauve.withOpacity(.18))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 23,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}