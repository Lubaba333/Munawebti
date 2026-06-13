import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dormitory_attendance_controller.dart';
import '../utlis/app_colors.dart';
import 'dormitory_attendance_detail_view.dart';

class DormitoryAttendanceView extends StatelessWidget {
  DormitoryAttendanceView({super.key});

  final controller = Get.put(DormitoryAttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),

      appBar: AppBar(
        title: const Text("حضور السكن"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.attendanceList.isEmpty) {
          return const Center(child: Text("لا يوجد سجلات"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAttendance(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.attendanceList.length,
            itemBuilder: (_, i) {
              final item = controller.attendanceList[i];
              return _card(item);
            },
          ),
        );
      }),
    );
  }

  Widget _card(item) {
    final isPresent = item.status == 'present';

    return GestureDetector(
      onTap: () async {
        await controller.fetchAttendanceDetails(item.id);
        Get.to(() => const DormitoryAttendanceDetailView());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              isPresent ? Icons.home : Icons.logout,
              color: isPresent ? Colors.green : Colors.red,
              size: 30,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPresent ? "داخل السكن" : "خارج السكن",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(item.createdAt),
                ],
              ),
            ),

            Text(
              isPresent ? "Present" : "Absent",
              style: TextStyle(
                color: isPresent ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}