
import 'package:flutter/material.dart';
import 'package:supervisors/models/StudentModel.dart';

class StudentHeader extends StatelessWidget {
  final StudentModel student;

  const StudentHeader({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          CircleAvatar(
            radius: 45,
            child: Text(
              student.fullName[0],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            student.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            student.studentIdentifier,
          ),
        ],
      ),
    );
  }
}