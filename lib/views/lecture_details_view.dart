import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lecture_details_controller.dart';
import '../utlis/app_colors.dart';

class LectureDetailsView extends StatelessWidget {
  final int lectureId;

  const LectureDetailsView({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LectureDetailsController(lectureId));

    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("Lecture Details"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.lecture.isEmpty) {
          return const Center(child: Text("No details found"));
        }

        final lecture = controller.lecture;

        final isPresent = lecture['status'] == 'present';

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🎓 CARD رئيسي
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPresent
                        ? [Colors.green.shade400, Colors.green.shade200]
                        : [Colors.red.shade400, Colors.red.shade200],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Icon(
                      isPresent ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 50,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      lecture['lecture_name'] ?? 'No Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isPresent ? "Present" : "Absent",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 📋 DETAILS
              _buildItem("Date", lecture['created_at']),
              _buildItem("Doctor", lecture['doctor_name']),
              _buildItem("Notes", lecture['notes']),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItem(String title, dynamic value) {
    if (value == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value.toString())),
        ],
      ),
    );
  }
}