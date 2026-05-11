import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studants/widgets/custom_textfield.dart';
import 'package:studants/widgets/gradient_button.dart';
import '../controllers/profile_controller.dart';
import '../../../utlis/app_colors.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = controller.name.value;
    emailController.text = controller.email.value;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _background(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔝 HEADER
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.darkPurple),
                      ),
                      const Spacer(),
                      const Text("Profile",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),

                      Obx(() => GestureDetector(
                            onTap: () {
                              controller.isEditing.value =
                                  !controller.isEditing.value;
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.edit,
                                    size: 18,
                                    color: AppColors.darkPurple),
                                const SizedBox(width: 5),
                                Text(
                                  controller.isEditing.value
                                      ? "إلغاء"
                                      : "تعديل",
                                  style: const TextStyle(
                                      color: AppColors.darkPurple),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),

                  const SizedBox(height: 18), // 🔽 تقليل مسافة

                  /// 👤 PROFILE IMAGE
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          return GestureDetector(
                            onTap: () => _showImagePreview(),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
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
                                backgroundImage:
                                    controller.profileImage.value != null
                                        ? FileImage(
                                            controller.profileImage.value!)
                                        : null,
                                child:
                                    controller.profileImage.value == null
                                        ? const Icon(Icons.person, size: 45)
                                        : null,
                              ),
                            ),
                          );
                        }),

                        /// 📸 زر الكاميرا
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.mauve,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading:
                                              const Icon(Icons.camera_alt),
                                          title: const Text("Camera"),
                                          onTap: () {
                                            controller.pickImage(
                                                ImageSource.camera);
                                            Get.back();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const Text("Gallery"),
                                          onTap: () {
                                            controller.pickImage(
                                                ImageSource.gallery);
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                );
                              },
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 18), // 🔽 تقليل

                  /// 🔒 STUDENT ID
                  _label("Student ID"),
                  Obx(() => CustomTextField(
                        controller:
                            TextEditingController(text: controller.studentId),
                        hint: "Student ID",
                        icon: Icons.badge,
                        enabled: false,
                      )),

                  const SizedBox(height: 8), // 🔽 تقليل

                  /// 🔒 ROOM
                  _label("Room"),
                  Obx(() => CustomTextField(
                        controller:
                            TextEditingController(text: controller.room),
                        hint: "Room",
                        icon: Icons.meeting_room,
                        enabled: false,
                      )),

                  const SizedBox(height: 8),

                  /// ✏️ NAME
                  _label("Name"),
                  Obx(() => CustomTextField(
                        controller: nameController,
                        hint: "Enter your name",
                        icon: Icons.person,
                        enabled: controller.isEditing.value,
                      )),

                  const SizedBox(height: 8),

                  /// ✏️ EMAIL
                  _label("Email"),
                  Obx(() => CustomTextField(
                        controller: emailController,
                        hint: "Enter your email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        enabled: controller.isEditing.value,
                      )),

                  const SizedBox(height: 15),

                  /// 💾 SAVE
                  Obx(() => controller.isEditing.value
                      ? GradientButton(
                          text: "Save",
                          onTap: () async {
                            bool success =
                                await controller.updateProfile(
                              newName: nameController.text,
                              newEmail: emailController.text,
                            );

                            if (success) {
                              controller.isEditing.value = false;

                              Get.snackbar(
                                "Success",
                                "تم الحفظ",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                controller.errorMessage.value,
                              );
                            }
                          },
                        )
                      : const SizedBox()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🖼️ عرض الصورة + تعديل + حذف
  void _showImagePreview() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final img = controller.profileImage.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// الصورة
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: img != null
                    ? Image.file(img, height: 250, fit: BoxFit.cover)
                    : const Icon(Icons.person, size: 120),
              ),

              const SizedBox(height: 20),

              /// تعديل
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("تعديل الصورة"),
                onTap: () {
                  Get.back();
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text("Camera"),
                            onTap: () {
                              controller.pickImage(ImageSource.camera);
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text("Gallery"),
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
                },
              ),

              /// حذف
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("حذف الصورة"),
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

  /// 🌸 الخلفية
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
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.darkPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}