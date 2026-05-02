import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_colors.dart';
import 'package:my_app/controller/AuthController.dart';

class SignUpView extends StatelessWidget {
  final controller = Get.find<AuthController>();

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔥 Gradient
          _background(),

          /// 🔹 Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                      /// 🔥 الشعار (Avatar)
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/munawebti.jpg",
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),



                    const SizedBox(height: 15),

                    /// 🔥 Glass Card
                    _glassCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [

              _field("Username", Icons.person,
                  (v) => controller.username.value = v),

              const SizedBox(height: 15),

              _field("Email", Icons.email,
                  (v) => controller.email.value = v),

              const SizedBox(height: 15),

              Obx(() => _field(
                    "Password",
                    Icons.lock,
                    (v) => controller.password.value = v,
                    isPassword: controller.isPasswordHidden.value,
                    suffix: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textLight
                      ),
                      onPressed: controller.togglePassword,
                    ),
                  )),

              const SizedBox(height: 25),

              _button("Sign Up", controller.signup),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: () => Get.back(),
                child: const Text(
                  "Already have account? Login",
                  style: TextStyle(
                    // color: Colors.white70,
                 color: AppColors.textLight
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.mainGradient,
            ),
          ),
        ),
        Positioned(top: -50, left: -50, child: _blurCircle(200)),
        Positioned(bottom: -60, right: -60, child: _blurCircle(250)),
      ],
    );
  }

  Widget _field(String hint, IconData icon, Function(String) onChanged,
      {bool isPassword = false, Widget? suffix}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        obscureText: isPassword,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.textLight),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight),
          border: InputBorder.none,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
  colors: AppColors.buttonGradient,
),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:  Color(0xFFA467A7).withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Center(
          child: Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _blurCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}