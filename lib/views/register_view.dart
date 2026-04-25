import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/login.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final AuthController controller = Get.put(AuthController());


  final nameController = TextEditingController();
final  studentIdController=TextEditingController();
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
            /// 🌸 الخلفية
            _background(),

            /// 📄 المحتوى
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

  /// 🎨 الخلفية
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

  /// 🏷️ Header
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

  /// 🪟 الفورم
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
              hint: " User Name",
              icon: Icons.badge,
            ),
           /* CustomTextField(
  controller: studentIdController,
  hint: "University ID",
  icon: Icons.badge,
  keyboardType: TextInputType.number,
),*/
            CustomTextField(
              controller: emailController,
              hint: "Email",
              icon: Icons.email,
            ),

            /// 🔒 Password
             CustomTextField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),


            const SizedBox(height: 20),

            /// 🚀 Register Button
            Obx(() => GradientButton(
                  text: controller.isLoading.value
                      ? "Loading..."
                      : "Register",
                  onTap: () {
                    final user = UserModel(
            
                      name: nameController.text,
                     // studentId: studentIdController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    controller.register(user);
                  },
                )),

            const SizedBox(height: 20),

            /// 🔁 Go to Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account? "),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginView()); // 🔥 بدون Routes
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