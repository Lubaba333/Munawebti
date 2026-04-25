// lib/modules/profile/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../utlis/app_colors.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,

      body: Stack(
        children: [

          /// 💜 الخلفية Gradient
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.darkPurple,
                  AppColors.mauve,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                /// 🔙 AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      const Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 👤 Avatar + Name
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 45,
                            color: AppColors.darkPurple),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Obx(() => Text(
                          controller.name.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),

                const SizedBox(height: 25),

                /// 💎 Glass Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [

                        /// 📄 Info
                        _infoTile(Icons.email, "Email",
                            controller.email),

                        _infoTile(Icons.badge, "Student ID",
                            controller.studentId),

                        _infoTile(Icons.home, "Room",
                            controller.room),

                        const SizedBox(height: 20),

                        /// ⚙️ Actions
                        _actionTile(Icons.edit, "Edit Profile"),
                       

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO TILE =================
  Widget _infoTile(
      IconData icon, String title, RxString value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkPurple),
          const SizedBox(width: 10),

          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),

          const Spacer(),

          Obx(() => Text(
                value.value,
                style: const TextStyle(color: Colors.grey),
              )),
        ],
      ),
    );
  }

  // ================= ACTION TILE =================
  Widget _actionTile(IconData icon, String title,
      {Color color = AppColors.darkPurple}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}