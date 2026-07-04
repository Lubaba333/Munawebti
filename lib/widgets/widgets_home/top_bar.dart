import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/controllers/home_controller.dart';
import 'package:studants/views/NotificationsView.dart';
import 'package:studants/views/profile_view.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDark = Get.isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.to(() => ProfileView()),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.mauve : AppColors.darkPurple,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(.20)
                      : AppColors.mauve.withOpacity(.20),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Obx(() {
              final profileController = Get.find<ProfileController>();
              final img = profileController.profileImage.value;

              return CircleAvatar(
                radius: 20,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(.08)
                    : AppColors.mauve.withOpacity(.30),
                backgroundImage: img != null ? FileImage(img) : null,
                child: img == null
                    ? Icon(
                        Icons.person,
                        color: isDark ? AppColors.mauve : AppColors.darkPurple,
                      )
                    : null,
              );
            }),
          ),
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: () => Get.to(() => NotificationsView()),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).cardColor.withOpacity(.92)
                      : Colors.white.withOpacity(.70),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.mauve.withOpacity(.18)
                        : Colors.white.withOpacity(.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(.22)
                          : Colors.black.withOpacity(.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications,
                  color: isDark ? AppColors.mauve : AppColors.darkPurple,
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Obx(() {
                if (controller.notificationCount.value == 0) {
                  return const SizedBox();
                }

                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      controller.notificationCount.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}