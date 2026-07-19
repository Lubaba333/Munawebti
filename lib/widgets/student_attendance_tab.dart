import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentAttendanceTab
    extends StatelessWidget {

  final int studentId;

  const StudentAttendanceTab({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
      const EdgeInsets.all(16),

      children: [

        Card(
          child: ListTile(
            leading:
            const Icon(Icons.check_circle),
            title:
            Text("programming_lecture".tr),
            subtitle: Text("present".tr),
          ),
        ),

        Card(
          child: ListTile(
            leading:
            const Icon(Icons.cancel),
            title:
            Text("housing".tr),
            subtitle: Text("absent".tr),
          ),
        ),
      ],
    );
  }
}