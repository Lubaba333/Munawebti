import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/DashboardController.dart';


class MenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;

  const MenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return MouseRegion(
        onEnter: (_) => {}, // يمكنك إضافة hover state هنا
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    });
  }
}