import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/reset_password_view.dart';

import '../controllers/auth_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final AuthController controller = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.login, color: Colors.white, size: 35),
          SizedBox(height: 10),
          Text(
            "Welcome Back",
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
      child: Column(
        children: [
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


          const SizedBox(height: 20),


/// 🔑 Forgot Password
Align(
  alignment: Alignment.centerRight,
  child: GestureDetector(
    onTap: () {
      Get.to(() => ResetPasswordView()); // 🔥 الانتقال
    },
    child: const Text(
      "Forgot Password?",
      style: TextStyle(
        color: AppColors.deepPurple,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    ),
  ),
),
const SizedBox(height: 20),
          Obx(() => GradientButton(
                text: controller.isLoading.value
                    ? "Loading..."
                    : "Login",
                onTap: () {
                  controller.login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                },
              )),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have account? "),
              GestureDetector(
                onTap: () {
                  Get.to(() => RegisterView()); // 🔥 بدون Routes
                },
                child: const Text(
                  "Register",
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
    );
  }
}