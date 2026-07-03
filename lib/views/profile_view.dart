import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/profile_controller.dart';
import '../../../utlis/app_colors.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.getProfile();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Obx(() {
              nameController.text = controller.name.value;
              emailController.text = controller.email.value;

              if (controller.isLoading.value && controller.name.value.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 18),
                    _profileImage(),
                    const SizedBox(height: 20),

                    _readonlyInfo(
                      icon: Icons.badge,
                      label: "student_id".tr,
                      value: controller.studentId,
                    ),
                    _readonlyInfo(
                      icon: Icons.phone,
                      label: "phone".tr,
                      value: controller.phone.value,
                    ),
                    _readonlyInfo(
                      icon: Icons.school,
                      label: "year".tr,
                      value: controller.year.value,
                    ),
                    _readonlyInfo(
  icon: Icons.groups,
  label: "group".tr,
  value: controller.group,
),
                    _readonlyInfo(
                      icon: Icons.menu_book,
                      label: "specialization".tr,
                      value: controller.specialization.value,
                    ),
                    _readonlyInfo(
                      icon: Icons.percent,
                      label: "annual_average".tr,
                      value: controller.annualAverage.value.isEmpty
                          ? "not_specified".tr
                          : controller.annualAverage.value,
                    ),
                    _readonlyInfo(
                      icon: Icons.home_work,
                      label: "dormitory_status".tr,
                      value: controller.isResident.value
                          ? "resident_in_dormitory".tr
                          : "not_resident".tr,
                    ),
                    _readonlyInfo(
                      icon: Icons.meeting_room,
                      label: "room".tr,
                      value: controller.room,
                    ),
                    if (controller.roomUnit.isNotEmpty)
                      _readonlyInfo(
                        icon: Icons.apartment,
                        label: "dormitory_unit".tr,
                        value: controller.roomUnit,
                      ),

                    const SizedBox(height: 10),

                    _readonlyInfo(
                      icon: Icons.person,
                      label: "name".tr,
                      value: controller.name.value,
                    ),

                    _readonlyInfo(
                      icon: Icons.email,
                      label: "email".tr,
                      value: controller.email.value,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.darkPurple),
        ),
        const Spacer(),
        Text(
          "profile".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _profileImage() {
    return Center(
      child: Stack(
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () => _showImagePreview(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.lightPink,
                      AppColors.mauve,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mauve.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : null,
                  child: controller.profileImage.value == null
                      ? const Icon(Icons.person, size: 45)
                      : null,
                ),
              ),
            );
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showPickImageSheet,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.mauve,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readonlyInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    if (value.trim().isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mauve.withOpacity(.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkPurple),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(
              color: AppColors.darkPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showPickImageSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text("camera".tr),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text("gallery".tr),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _showImagePreview() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final img = controller.profileImage.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: img != null
                    ? Image.file(img, height: 250, fit: BoxFit.cover)
                    : const Icon(Icons.person, size: 120),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text("edit_image".tr),
                onTap: () {
                  Get.back();
                  _showPickImageSheet();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text("delete_image".tr),
                onTap: () {
                  controller.profileImage.value = null;
                  Get.back();
                },
              ),
            ],
          );
        }),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _circle(200, AppColors.lightPink.withOpacity(0.5)),
        ),
        Positioned(
          top: 120,
          right: -60,
          child: _circle(180, AppColors.mauve.withOpacity(0.4)),
        ),
        Positioned(
          bottom: -80,
          left: 60,
          child: _circle(220, AppColors.deepPurple.withOpacity(0.3)),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}