import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/lecture_details_view.dart';
import '../controllers/lecture_controller.dart';
import '../utlis/app_colors.dart';

class LecturesView extends StatelessWidget {
  LecturesView({super.key});

  final LectureController controller = Get.put(LectureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("My Lectures"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.lectures.isEmpty) {
          return const Center(child: Text("No lectures found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.lectures.length,
          itemBuilder: (context, index) {
            final lecture = controller.lectures[index];
            return _buildLectureCard(lecture);
          },
        );
      }),
    );
  }

  Widget _buildLectureCard(lecture) {
    final isPresent = lecture.status == 'present';

  
    return GestureDetector(
  onTap: () {
    Get.to(() => LectureDetailsView(lectureId: lecture.id));
  },
  child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPresent
              ? [Colors.green.shade400, Colors.green.shade200]
              : [Colors.red.shade400, Colors.red.shade200],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lecture.lectureName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  lecture.date,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Text(
            isPresent ? "Present" : "Absent",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ));
  }
}