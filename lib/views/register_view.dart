import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/login.dart';
import 'package:studants/views/otp.dart';

import '../controllers/auth_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final AuthController controller = Get.put(AuthController());

  final nameController = TextEditingController();
  final studentIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final yearController = TextEditingController();
  final specializationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.currentGradient,
        ),
        child: Stack(
          children: [
            _background(isDark),
            SafeArea(
              child: Column(
                children: [
                  _header(),
                  Expanded(child: _form(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background(bool isDark) {
    return Stack(
      children: [
        _circle(
          80,
          40,
          30,
          isDark ? AppColors.mauve.withOpacity(.20) : AppColors.lightPink,
        ),
        _circle(60, 100, 300, Colors.white.withOpacity(0.16)),
        _circle(
          100,
          600,
          -20,
          isDark ? Colors.black.withOpacity(.18) : AppColors.deepPurple,
        ),
        _circle(
          90,
          -20,
          300,
          isDark ? AppColors.mauve.withOpacity(.22) : AppColors.mauve,
        ),
      ],
    );
  }

  Widget _circle(double size, double top, double left, Color color) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.person_add, color: Colors.white, size: 35),
          const SizedBox(height: 10),
          Text(
            "create_account".tr,
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.25)
                : AppColors.deepPurple.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hint: "user_name".tr,
              icon: Icons.badge,
            ),
            CustomTextField(
              controller: studentIdController,
              hint: "student_id".tr,
              icon: Icons.numbers,
            ),
            CustomTextField(
              controller: emailController,
              hint: "email".tr,
              icon: Icons.email,
            ),
            CustomTextField(
              controller: passwordController,
              hint: "password".tr,
              icon: Icons.lock,
              isPassword: true,
            ),
            CustomTextField(
              controller: confirmPasswordController,
              hint: "confirm_password".tr,
              icon: Icons.lock,
              isPassword: true,
            ),
            CustomTextField(
              controller: phoneController,
              hint: "phone_number".tr,
              icon: Icons.phone,
            ),
            CustomTextField(
              controller: yearController,
              hint: "year".tr,
              icon: Icons.school,
            ),
            CustomTextField(
              controller: specializationController,
              hint: "specialization".tr,
              icon: Icons.computer,
            ),
            const SizedBox(height: 20),
            Obx(
              () => GradientButton(
                text:
                    controller.isLoading.value ? "loading".tr : "register".tr,
                isLoading: controller.isLoading.value,
                onTap: () async {
                  if (nameController.text.isEmpty ||
                      studentIdController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      specializationController.text.isEmpty) {
                    Get.snackbar(
                      "error".tr,
                      "fill_all_fields".tr,
                      backgroundColor:
                          isDark ? const Color(0xFF8B1E2D) : Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    Get.snackbar(
                      "error".tr,
                      "passwords_not_match".tr,
                      backgroundColor:
                          isDark ? const Color(0xFF8B1E2D) : Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final success = await controller.sendRegistrationOTP(
                    email: emailController.text,
                  );

                  if (success) {
                    Get.to(
                      () => const OtpVerificationView(),
                      arguments: {
                        'email': emailController.text,
                        'from': 'register',
                        'name': nameController.text,
                        'studentId': studentIdController.text,
                        'password': passwordController.text,
                        'confirmPassword': confirmPasswordController.text,
                        'phone': phoneController.text,
                        'year': yearController.text,
                        'specialization': specializationController.text,
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "already_have_account".tr,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginView());
                  },
                  child: Text(
                    "login".tr,
                    style: TextStyle(
                      color: isDark ? AppColors.mauve : AppColors.darkPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}