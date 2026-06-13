import 'package:flutter/material.dart';
import '../../../utlis/app_colors.dart';

class BottomNav extends StatelessWidget {
  /// الفهرس الحالي للصفحة المفتوحة
  final int currentIndex;
  
  /// دالة التبديل بين الصفحات
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
            /// 📅 محاضراتي
            _buildNavItem(0, Icons.calendar_month, "محاضراتي", Colors.grey),

            /// 🏠 الرئيسية - بارزة بالوسط (نفس التصميم لكن أصغر قليلاً)
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
                  size: 24,
                ),
              ),
            ),

            /// 📝 طلباتي
            _buildNavItem(2, Icons.request_page, "طلباتي", Colors.grey),

            /// 🚨 طوارئ - نفس التصميم لكن الأيقونة حمراء
            _buildNavItem(3, Icons.sos, "طوارئ", Colors.red),
          ],
        ),
      ),
    );
  }

  /// 🧩 عنصر التنقل (أيقونة + نص) - مع لون أيقونة مخصص
  Widget _buildNavItem(int index, IconData icon, String label, Color iconColor) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              // ✅ الأيقونة تأخذ اللون المخصص (أحمر للطوارئ)
              color: isSelected ? (iconColor == Colors.red ? Colors.red : AppColors.darkPurple) : iconColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                // ✅ النص أيضاً يتلون حسب الحالة
                color: isSelected ? (iconColor == Colors.red ? Colors.red : AppColors.darkPurple) : iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}