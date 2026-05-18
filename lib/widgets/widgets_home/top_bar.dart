
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// ☰ MENU (يفتح Drawer)
        Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.menu,
                color: AppColors.darkPurple,
              ),
            ),
          ),
        ),

        /// 🔔 + 👤
        Row(
          children: [

            /// 🔔 NOTIFICATIONS
            Stack(
              children: [

                GestureDetector(
                  onTap: () {
                    Get.to(NotificationsView());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: AppColors.darkPurple,
                    ),
                  ),
                ),

                /// 🔴 BADGE
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

            /// 👤 PROFILE
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileView());
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.mauve,
                    width: 2,
                  ),
                ),
 child: Obx(() {
  final profileController = Get.find<ProfileController>();
  final img = profileController.profileImage.value;

  return CircleAvatar(
    radius: 18,
    backgroundColor: AppColors.mauve.withOpacity(0.3),
    backgroundImage: img != null ? FileImage(img) : null,
    child: img == null
        ? const Icon(
            Icons.person,
            color: AppColors.darkPurple,
          )
        : null,
  );
}),
              ),
            ),
          ],
        ),
      ],
    );
  }
}