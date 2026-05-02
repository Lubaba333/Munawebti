import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_colors.dart';
import 'package:my_app/controller/AuthController.dart';
import 'package:my_app/view/OTPView.dart';

class ForgetPasswordView extends StatelessWidget {
  final controller = Get.find<AuthController>();

  ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔥 Background
          _background(),

          /// 🔹 Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ClipRRect(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Enter your email to receive reset link",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textLight),
                        ),

                        const SizedBox(height: 25),

                        _field(),

                        const SizedBox(height: 20),

                        _button(),

                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(
                              color: AppColors.textLight
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Widget _field() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (v) => controller.email.value = v,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          icon: Icon(Icons.email,  color: AppColors.textLight),
          hintText: "Email",
          hintStyle: TextStyle(  color: AppColors.textLight),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _button() {
    return GestureDetector(
      onTap: (){
        Get.to(() => OTPView());
      },
      
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
        child: const Center(
          child: Text(
            "Send Reset Link",
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
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