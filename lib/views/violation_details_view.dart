import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/violation_details_controller.dart';
import '../utlis/app_colors.dart';

class ViolationDetailsView extends StatelessWidget {
  final int id;

  const ViolationDetailsView({super.key, required this.id});

  static const violationRed = Color(0xFFD84A4A);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViolationDetailsController(id));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: const Text("تفاصيل المخالفة"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkPurple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mauve),
          );
        }

        if (controller.violation.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final v = controller.violation;

        return Stack(
          children: [
            _background(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _violationHeader(v['title'] ?? ''),
                  const SizedBox(height: 18),
                  _item(
                    title: "Description",
                    value: v['description'],
                    icon: Icons.description_outlined,
                  ),
                  _item(
                    title: "Date",
                    value: v['created_at'],
                    icon: Icons.calendar_month_rounded,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _violationHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: violationRed,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: violationRed.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.warning_amber_rounded,
              size: 110,
              color: Colors.white.withOpacity(.12),
            ),
          ),
         Center(
  child: Column(
            
  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(.35),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.gpp_bad_rounded,
                  color: Colors.white,
                  size: 45,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "VIOLATION",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),)
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required dynamic value,
    required IconData icon,
  }) {
    if (value == null) return const SizedBox();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: violationRed.withOpacity(.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurple.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: violationRed.withOpacity(.10),
            child: Icon(
              icon,
              color: violationRed,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _circle(200, AppColors.lightPink.withOpacity(0.40)),
        ),
        Positioned(
          top: 160,
          right: -70,
          child: _circle(190, violationRed.withOpacity(0.12)),
        ),
        Positioned(
          bottom: -90,
          left: 50,
          child: _circle(230, AppColors.mauve.withOpacity(0.22)),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}