import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/violation_controller.dart';
import '../utlis/app_colors.dart';
import 'violation_details_view.dart';

class ViolationsView extends StatelessWidget {
  ViolationsView({super.key});

  final controller = Get.put(ViolationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("My Violations"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.violations.isEmpty) {
          return const Center(
            child: Text("No violations "),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.violations.length,
          itemBuilder: (context, index) {
            final v = controller.violations[index];
            return _buildCard(v);
          },
        );
      }),
    );
  }

  Widget _buildCard(v) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViolationDetailsView(id: v.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade400,
              Colors.red.shade200,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.gpp_bad, color: Colors.white, size: 30),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    v.date,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}