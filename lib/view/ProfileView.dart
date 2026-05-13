import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/app_colors.dart';
import '../controller/ProfileController.dart';

class ProfileView extends StatelessWidget {
  final controller = Get.put(ProfileController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: Obx(() => FloatingActionButton(
            backgroundColor: AppColors.primary,
            child: Icon(
              controller.isEdit.value ? Icons.check : Icons.edit,
            ),
            onPressed: controller.toggleEdit,
          )),

      body: SingleChildScrollView(
        child: Column(
          children: [

            _header(),

            const SizedBox(height: 25),

            /// ✨ Animation دخول
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 500),
              tween: Tween(begin: 50.0, end: 0.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Opacity(
                    opacity: 1 - (value / 50),
                    child: child,
                  ),
                );
              },
              child: _infoCard(),
            ),

            const SizedBox(height: 20),

            _settings(),

            const SizedBox(height: 20),

            _logoutButton(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔥 HEADER + Glow Avatar
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 35),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.mainGradient),
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [

          /// Glow Avatar
          GestureDetector(
            onTap: () {
              if (controller.isEdit.value) {
                controller.pickImage();
              }
            },
            child: Obx(() => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    backgroundImage: controller.imageFile.value != null
                        ? FileImage(controller.imageFile.value!)
                        : null,
                    child: controller.imageFile.value == null
                        ? const Icon(Icons.person, size: 38)
                        : null,
                  ),
                )),
          ),

          const SizedBox(height: 12),

          Obx(() => controller.isEdit.value
              ? _editField(controller.nameCtrl)
              : Text(
                  controller.name.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),

          const SizedBox(height: 6),

          Obx(() => controller.isEdit.value
              ? _editField(controller.roleCtrl)
              : Text(
                  controller.role.value,
                  style: const TextStyle(color: Colors.white70),
                )),
        ],
      ),
    );
  }

  /// 📦 INFO CARD
  Widget _infoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
          )
        ],
      ),
      child: Column(
        children: [
          _row("Email", controller.emailCtrl, controller.email),
          const SizedBox(height: 10),
          _divider(),
          const SizedBox(height: 10),
          _row("Phone", controller.phoneCtrl, controller.phone),
        ],
      ),
    );
  }

  /// ⚙️ SETTINGS + Dark Mode
  Widget _settings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Obx(() => SwitchListTile(
                value: controller.isDark.value,
                onChanged: controller.toggleTheme,
                title: const Text("Dark Mode"),
              )),
        ],
      ),
    );
  }

  /// 🚪 Logout
  Widget _logoutButton() {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// 🔘 Row
  Widget _row(String title, TextEditingController ctrl, RxString value) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Expanded(
          flex: 2,
          child: Obx(() => controller.isEdit.value
              ? TextField(
                  controller: ctrl,
                  textAlign: TextAlign.end,
                  decoration:
                      const InputDecoration(border: InputBorder.none),
                )
              : Text(
                  value.value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.grey),
                )),
        )
      ],
    );
  }

  Widget _editField(TextEditingController ctrl) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: ctrl,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }
}