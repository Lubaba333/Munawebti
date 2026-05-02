
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_colors.dart';
import 'package:my_app/controller/AuthController.dart';
import 'package:my_app/view/ForgetPasswordView.dart';
import 'package:my_app/view/HomeView.dart';

import 'package:my_app/view/SignUpView.dart';


class LoginView extends StatelessWidget {
  final controller = Get.put(AuthController());

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔥 Gradient Background (احترافي)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
               colors: AppColors.mainGradient,
              ),
            ),
          ),

          /// 🔥 Glow effect خفيف
          Positioned(
            top: -50,
            left: -50,
            child: _blurCircle(200),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: _blurCircle(250),
          ),

          /// 🔹 Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
            Column(
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

                /// 🔥 اسم التطبيق (محسّن)
                const Text(
                  "Munawebti",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2, // ✨ لمسة احترافية
                  ),
                ),
              ],
            ),


                    const SizedBox(height: 15),

                    /// 🔥 Glass Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                           color: AppColors.glass,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [

                              const Text(
                                "Welcome",
                                style: TextStyle(
                                  fontSize: 22,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 25),

                                                      _field(
                            icon: Icons.email,
                            hint: "Email",
                            onChanged: (v) => controller.email.value = v,
                          ),
                                                      

                              const SizedBox(height: 15),

                              /// Password
                              Obx(() => _field(
                                    icon: Icons.lock,
                                    hint: "Password",
                                    isPassword:
                                        controller.isPasswordHidden.value,
                                    onChanged: (v) =>
                                        controller.password.value = v,
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

                              const SizedBox(height: 10),

                              /// Remember + Forgot
                              Row(
                                children: [
                                  Obx(() => Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged:
                                            controller.toggleRemember,
                                        activeColor: Colors.white,
                                      )),
                                  const Text("Remember",
                                      style: TextStyle(color: Colors.white)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () =>
                                        Get.to(() => ForgetPasswordView()),
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                       color: AppColors.textLight,
                                       // decoration:
                                          //  TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 20),

                                                  Obx(() => GestureDetector(
                      onTap: controller.isLoading.value
                          ? null
                          : () => controller.login(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                             gradient: LinearGradient(
                             colors: AppColors.buttonGradient,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Login", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )),

                              const SizedBox(height: 20),

                              /// Sign up
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("New user? ",
                                      style: TextStyle(color: Colors.white)),
                                  GestureDetector(
                                    onTap: () =>
                                        Get.to(() => SignUpView()),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      //  decoration:
                                        //    TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 TextField حديث
  Widget _field({
    required IconData icon,
    required String hint,
    required Function(String) onChanged,
    bool isPassword = false,
    Widget? suffix,
  }) {
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

  /// 🔥 blur circle
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