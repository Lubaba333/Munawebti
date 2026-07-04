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
    final isDark = Get.isDarkMode;

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
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.mauve),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    const SizedBox(height: 18),
                    _profileImage(),
                    const SizedBox(height: 20),
                    _readonlyInfo(
                      context,
                      icon: Icons.badge,
                      label: "student_id".tr,
                      value: controller.studentId,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.phone,
                      label: "phone".tr,
                      value: controller.phone.value,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.school,
                      label: "year".tr,
                      value: controller.year.value,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.groups,
                      label: "group".tr,
                      value: controller.group,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.menu_book,
                      label: "specialization".tr,
                      value: controller.specialization.value,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.percent,
                      label: "annual_average".tr,
                      value: controller.annualAverage.value.isEmpty
                          ? "not_specified".tr
                          : controller.annualAverage.value,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.home_work,
                      label: "dormitory_status".tr,
                      value: controller.isResident.value
                          ? "resident_in_dormitory".tr
                          : "not_resident".tr,
                    ),
                    _readonlyInfo(
                      context,
                      icon: Icons.meeting_room,
                      label: "room".tr,
                      value: controller.room,
                    ),
                    if (controller.roomUnit.isNotEmpty)
                      _readonlyInfo(
                        context,
                        icon: Icons.apartment,
                        label: "dormitory_unit".tr,
                        value: controller.roomUnit,
                      ),
                    const SizedBox(height: 10),
                    _readonlyInfo(
                      context,
                      icon: Icons.person,
                      label: "name".tr,
                      value: controller.name.value,
                    ),
                    _readonlyInfo(
                      context,
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

  Widget _header(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(.07)
                : Colors.white.withOpacity(.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? AppColors.mauve.withOpacity(.18)
                  : AppColors.mauve.withOpacity(.16),
            ),
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? AppColors.mauve : AppColors.darkPurple,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "profile".tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 45),
      ],
    );
  }

  Widget _profileImage() {
    final isDark = Get.isDarkMode;

    return Center(
      child: Stack(
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () => _showImagePreview(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.mauve.withOpacity(.85),
                            AppColors.darkPurple.withOpacity(.75),
                          ]
                        : const [
                            AppColors.lightPink,
                            AppColors.mauve,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(.28)
                          : AppColors.mauve.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Get.theme.cardColor,
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : null,
                  child: controller.profileImage.value == null
                      ? Icon(
                          Icons.person,
                          size: 45,
                          color:
                              isDark ? AppColors.mauve : AppColors.darkPurple,
                        )
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
                decoration: BoxDecoration(
                  color: isDark ? AppColors.mauve : AppColors.darkPurple,
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

  Widget _readonlyInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    if (value.trim().isEmpty) return const SizedBox();

    final isDark = Get.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).cardColor.withOpacity(.92)
            : Colors.white.withOpacity(.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.mauve.withOpacity(.20)
              : AppColors.mauve.withOpacity(.18),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.16)
                : AppColors.deepPurple.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppColors.mauve : AppColors.darkPurple,
          ),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: TextStyle(
              color: isDark ? AppColors.mauve : AppColors.darkPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPickImageSheet() {
    final isDark = Get.isDarkMode;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: isDark ? AppColors.mauve.withOpacity(.16) : Colors.transparent,
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: isDark ? AppColors.mauve : AppColors.darkPurple,
              ),
              title: Text(
                "camera".tr,
                style: TextStyle(color: Get.textTheme.titleMedium?.color),
              ),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo,
                color: isDark ? AppColors.mauve : AppColors.darkPurple,
              ),
              title: Text(
                "gallery".tr,
                style: TextStyle(color: Get.textTheme.titleMedium?.color),
              ),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _showImagePreview() {
    final isDark = Get.isDarkMode;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: isDark ? AppColors.mauve.withOpacity(.16) : Colors.transparent,
          ),
        ),
        child: Obx(() {
          final img = controller.profileImage.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: img != null
                    ? Image.file(img, height: 250, fit: BoxFit.cover)
                    : Icon(
                        Icons.person,
                        size: 120,
                        color: isDark ? AppColors.mauve : AppColors.darkPurple,
                      ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: isDark ? AppColors.mauve : AppColors.darkPurple,
                ),
                title: Text(
                  "edit_image".tr,
                  style: TextStyle(color: Get.textTheme.titleMedium?.color),
                ),
                onTap: () {
                  Get.back();
                  _showPickImageSheet();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  "delete_image".tr,
                  style: TextStyle(color: Get.textTheme.titleMedium?.color),
                ),
                onTap: () {
                  controller.profileImage.value = null;
                  Get.back();
                },
              ),
            ],
          );
        }),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _background() {
    final isDark = Get.isDarkMode;

    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _circle(
            200,
            isDark
                ? AppColors.mauve.withOpacity(0.12)
                : AppColors.lightPink.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: 120,
          right: -60,
          child: _circle(
            180,
            isDark
                ? AppColors.deepPurple.withOpacity(0.12)
                : AppColors.mauve.withOpacity(0.4),
          ),
        ),
        Positioned(
          bottom: -80,
          left: 60,
          child: _circle(
            220,
            isDark
                ? Colors.black.withOpacity(0.16)
                : AppColors.deepPurple.withOpacity(0.3),
          ),
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