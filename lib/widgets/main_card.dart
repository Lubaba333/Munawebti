import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../utlis/app_colors.dart';

class MainCard extends StatelessWidget {
  final AnimationController animController;
  const MainCard({super.key, required this.animController});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.darkPurple, AppColors.mauve],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("المناوبة القادمة",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),
                    Obx(() => Text(
                          controller.hospital.value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 5),
                        Obx(() => Text(controller.time.value,
                            style:
                                const TextStyle(color: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: [
                _floating(Icons.favorite, 20, 70),
                _floating(Icons.favorite_border, 70, 220),
                _floating(Icons.medical_services, 30, 180),
                _floating(Icons.health_and_safety, 50, 260),
                _floating(Icons.local_hospital, 40, 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _floating(IconData icon, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: animController,
        builder: (_, __) {
          double scale = 0.8 + (animController.value * 0.4);
          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: 0.25 + (animController.value * 0.2),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}