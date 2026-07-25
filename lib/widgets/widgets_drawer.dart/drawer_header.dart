import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 35, 24, 25),
      child: Column(
        children: [
          Obx(() {
            final image = controller.profileImage.value;

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage:
                    image != null ? FileImage(image) : null,
                child: image == null
                    ? const Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.deepPurple,
                      )
                    : null,
              ),
            );
          }),

          const SizedBox(height: 18),

          Obx(
            () => Text(
              controller.name.value.isEmpty
                  ? "student".tr
                  : controller.name.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                controller.email.value.isEmpty
                    ? "example@email.com"
                    : controller.email.value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}