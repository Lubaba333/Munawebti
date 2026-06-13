import 'package:flutter/material.dart';
import 'package:supervisors/models/StudentModel.dart';

class StudentActionsSheet
    extends StatelessWidget {

  final StudentModel student;

  const StudentActionsSheet({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
      const EdgeInsets.all(20),

      decoration:
      const BoxDecoration(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      child: Wrap(
        children: [

          ListTile(
            leading:
            const Icon(Icons.warning),
            title:
            const Text("إضافة تحذير"),
            onTap: () {},
          ),

          ListTile(
            leading:
            const Icon(Icons.block),
            title:
            const Text("إضافة مخالفة"),
            onTap: () {},
          ),

          ListTile(
            leading:
            const Icon(Icons.star),
            title:
            const Text("إضافة مكافأة"),
            onTap: () {},
          ),

          ListTile(
            leading:
            const Icon(Icons.article),
            title:
            const Text("إضافة تقرير"),
            onTap: () {},
          ),

          ListTile(
            leading:
            const Icon(Icons.emergency),
            title:
            const Text("حالة طارئة"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}