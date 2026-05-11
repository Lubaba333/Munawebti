import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

          Obx(() {
            final img = controller.profileImage.value;

            return CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              backgroundImage: img != null ? FileImage(img) : null,
              child: img == null
                  ? const Icon(Icons.person, size: 40, color: Colors.deepPurple)
                  : null,
            );
          }),

          const SizedBox(height: 12),

          Obx(() => Text(
                controller.name.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),

          const SizedBox(height: 6),

          Obx(() => Text(
                controller.email.value,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              )),
        ],
      ),
    );
  }
}