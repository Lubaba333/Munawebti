import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dormitory_attendance_controller.dart';

class DormitoryAttendanceDetailView extends StatelessWidget {
  const DormitoryAttendanceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DormitoryAttendanceController>();

    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل الحضور")),

      body: Obx(() {
        final item = controller.selectedAttendance.value;

        if (item == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("الحالة: ${item.status}"),
              Text("التاريخ: ${item.createdAt}"),
            ],
          ),
        );
      }),
    );
  }
}