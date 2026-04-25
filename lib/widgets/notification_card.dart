import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../utlis/app_colors.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: AppColors.darkPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() => Text(
                  "لديك ${controller.notificationCount.value} إشعارات",
                  style: const TextStyle(color: AppColors.darkPurple),
                )),
          ),
        ],
      ),
    );
  }
}