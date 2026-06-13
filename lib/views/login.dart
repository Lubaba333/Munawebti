import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/reset_password_view.dart';

import '../controllers/auth_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final AuthController controller = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final studantIdController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _headerSlide;
  late Animation<Offset> _formSlide;
  late Animation<double> _formScale;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _fade = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _formScale = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    passwordController.dispose();
    studantIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.mainGradient,
          ),
          child: Stack(
            children: [
              _background(),

              SafeArea(
                child: Column(
                  children: [
                    SlideTransition(
                      position: _headerSlide,
                      child: _header(),
                    ),
                    Expanded(
                      child: SlideTransition(
                        position: _formSlide,
                        child: ScaleTransition(
                          scale: _formScale,
                          child: _form(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.75 + (_animController.value * 0.25),
            child: Opacity(
              opacity: _animController.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: emailController,
              hint: "Email",
              icon: Icons.email,
            ),
            CustomTextField(
              controller: studantIdController,
              hint: "Studant ID",
              icon: Icons.numbers,
            ),
            CustomTextField(
              controller: passwordController,
              hint: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ResetPasswordView());
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

            Obx(
              () => GradientButton(
                text: controller.isLoading.value ? "Loading..." : "Login",
                onTap: () {
                  controller.login(
                    email: emailController.text,
                    password: passwordController.text,
                    studantid: studantIdController.text,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account? "),
                GestureDetector(
                  onTap: () {
                    Get.to(() => RegisterView());
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
      ),
    );
  }
}