// lib/views/register_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/login.dart';
import 'package:studants/views/otp.dart';
import 'package:studants/views/otp_verification_view.dart';

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: Stack(
          children: [
            _background(),
            SafeArea(
              child: Column(
                children: [
                  _header(),
                  Expanded(child: _form()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        _circle(80, 40, 30, AppColors.lightPink),
        _circle(60, 100, 300, Colors.white.withOpacity(0.2)),
        _circle(100, 600, -20, AppColors.deepPurple),
        _circle(90, -20, 300, AppColors.mauve),
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
        children: const [
          Icon(Icons.person_add, color: Colors.white, size: 35),
          SizedBox(height: 10),
          Text(
            "Create Account",
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hint: "User Name",
              icon: Icons.badge,
            ),
            CustomTextField(
              controller: studentIdController,
              hint: "Student ID",
              icon: Icons.numbers,
            ),
            CustomTextField(
              controller: emailController,
              hint: "Email",
              icon: Icons.email,
            ),
            CustomTextField(
              controller: passwordController,
              hint: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            CustomTextField(
              controller: confirmPasswordController,
              hint: "Confirm Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            CustomTextField(
              controller: phoneController,
              hint: "Phone Number",
              icon: Icons.phone,
            ),
            CustomTextField(
              controller: yearController,
              hint: "Year",
              icon: Icons.school,
            ),
            CustomTextField(
              controller: specializationController,
              hint: "Specialization",
              icon: Icons.computer,
            ),
            const SizedBox(height: 20),

            Obx(() => GradientButton(
              text: controller.isLoading.value ? "Loading..." : "Register",
              onTap: () async {
                if (nameController.text.isEmpty ||
                    studentIdController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    specializationController.text.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please fill all fields",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                
                if (passwordController.text != confirmPasswordController.text) {
                  Get.snackbar(
                    "Error",
                    "Passwords do not match",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                
                final success = await controller.sendRegistrationOTP(
                  email: emailController.text,
                );
                
                if (success) {
                  Get.to(() => OtpVerificationView(), arguments: {
                    'email': emailController.text,
                    'name': nameController.text,
                    'studentId': studentIdController.text,
                    'password': passwordController.text,
                    'confirmPassword': confirmPasswordController.text,
                    'phone': phoneController.text,
                    'year': yearController.text,
                    'specialization': specializationController.text,
                  });
                }
              },
            )),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account? "),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginView());
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: AppColors.darkPurple,
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