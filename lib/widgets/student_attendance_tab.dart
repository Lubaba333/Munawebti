import 'package:flutter/material.dart';

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

      children: const [

        Card(
          child: ListTile(
            leading:
            Icon(Icons.check_circle),
            title:
            Text("محاضرة البرمجة"),
            subtitle: Text("حاضر"),
          ),
        ),

        Card(
          child: ListTile(
            leading:
            Icon(Icons.cancel),
            title:
            Text("السكن"),
            subtitle: Text("غائب"),
          ),
        ),
      ],
    );
  }
}