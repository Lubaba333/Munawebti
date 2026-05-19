import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/warning_controller.dart';
import '../utlis/app_colors.dart';
import 'warning_details_view.dart';

class WarningsView extends StatelessWidget {
  WarningsView({super.key});

  final controller = Get.put(WarningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("My Warnings"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.warnings.isEmpty) {
          return const Center(
            child: Text("No warnings "),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.warnings.length,
          itemBuilder: (context, index) {
            final warning = controller.warnings[index];
            return _buildCard(warning);
          },
        );
      }),
    );
  }

  Widget _buildCard(warning) {
    return GestureDetector(
      onTap: () {
        Get.to(() => WarningDetailsView(id: warning.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade200,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white, size: 30),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    warning.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    warning.date,
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