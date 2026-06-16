import 'package:flutter/material.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'info_tile.dart';

class StudentInfoTab extends StatelessWidget {
  final StudentModel student;

  const StudentInfoTab({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
      const EdgeInsets.all(16),

      children: [
        InfoTile(
          title: "الاسم",
          value: student.fullName,
        ),

        InfoTile(
          title: "الرقم الجامعي",
          value: student.studentIdentifier,
        ),

        InfoTile(
          title: "الاختصاص",
          value: student.specialization,
        ),

      ],
    );
  }
}