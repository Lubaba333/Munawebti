import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/views/login.dart';
import 'package:studants/views/register_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _textSlide;
  late Animation<double> _fade;
  late Animation<Offset> _buttonsSlide;

  late List<Animation<Offset>> _sphereAnimations;

  final List<Offset> _finalPositions = [
    const Offset(-0.35, -0.25),
    const Offset(0.30, -0.20),
    const Offset(-0.30, 0.30),
    const Offset(0.25, 0.35),
    const Offset(0.20, -0.35),
  ];

  final List<double> _sphereSizes = [120, 80, 60, 100, 50];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _sphereAnimations = _finalPositions.map((pos) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: pos,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 236, 223, 234)
                          .withOpacity(0.95),
                      const Color.fromARGB(255, 210, 170, 206),
                      AppColors.deepPurple,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              ..._buildWaves(),
              ..._buildSpheres(w, h),

              SafeArea(
                child: Column(
                  children: [
                    const Spacer(),

                    Opacity(
                      opacity: _controller.value,
                      child: Transform.translate(
                        offset:
                            Offset(0, 40 * (1 - _controller.value) + 45),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 50,
                                sigmaY: 100,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Welcome to Studants App",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "A platform designed for students to access their services with ease.\nStay informed, manage your requests, and simplify your academic experience.\nEverything you need, all in one place.",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Opacity(
                      opacity: _controller.value,
                      child: Transform.translate(
                        offset: Offset(0, 60 * (1 - _controller.value)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Expanded(
                                child: _GlassActionButton(
                                  text: 'Sign up',
                                  icon: Icons.person_add_alt_1,
                                  onTap: () {
                                    Get.to(() => RegisterView());
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _GlassActionButton(
                                  text: 'Sign in',
                                  icon: Icons.login_rounded,
                                  onTap: () {
                                    Get.to(() => LoginView());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildWaves() {
    return [
      Positioned(
        top: -120,
        right: -120,
        child: _blurCircle(
          const Color.fromARGB(255, 255, 229, 250),
          0.50,
          400,
        ),
      ),
      Positioned(
        bottom: -160,
        left: -160,
        child: _blurCircle(
          const Color.fromARGB(255, 255, 251, 255),
          0.2,
          500,
        ),
      ),
    ];
  }

  Widget _blurCircle(Color color, double opacity, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(0.05),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSpheres(double w, double h) {
    return List.generate(5, (i) {
      return AnimatedBuilder(
        animation: _sphereAnimations[i],
        builder: (_, __) {
          final dx = _sphereAnimations[i].value.dx * w;
          final dy = _sphereAnimations[i].value.dy * h;

          return Positioned(
            left: (w / 2) + dx - (_sphereSizes[i] / 2),
            top: (h / 2) + dy - (_sphereSizes[i] / 2),
            child: Container(
              width: _sphereSizes[i],
              height: _sphereSizes[i],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.allSphereGradients[i],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 25,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class _GlassActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.48),
                  AppColors.deepPurple.withOpacity(0.58),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepPurple.withOpacity(0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 21),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}