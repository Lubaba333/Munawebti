import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/StudentsController.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/view/StudentDetailsView.dart';


class StudentsView extends GetView<StudentsController> {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          controller.loadStudents(refresh: true);
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StudentsSearchBar(
                controller: controller.searchController,
                onChanged: controller.searchStudents,
              ),

              const SizedBox(height: 16),

              /// Filters (مبسطة حسب الباك)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _chip('الكل', 'all'),
                    _chip('مقيم', 'resident'),
                    _chip('غير مقيم', 'non_resident'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// LIST
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.students.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.filteredStudents.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد طلاب'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.loadStudents(refresh: true),
                    child: ListView.builder(
                      itemCount: controller.filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = controller.filteredStudents[index];

                        return StudentCard(
                          student: student,
                          onTap: () {
                            Get.to(
                                  () =>  StudentDetailsView(),
                              arguments: student,
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CHIP FILTER
  Widget _chip(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.selectedFilter.value == value;

        return ChoiceChip(
          label: Text(title),
          selected: selected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
          onSelected: (_) => controller.changeFilter(value),
        );
      }),
    );
  }
}


class StudentCard extends StatelessWidget {
final StudentModel student;
final VoidCallback onTap;

const StudentCard({
super.key,
required this.student,
required this.onTap,
});

@override
Widget build(BuildContext context) {
return InkWell(
borderRadius: BorderRadius.circular(22),
onTap: onTap,
child: Container(
margin: const EdgeInsets.only(bottom: 14),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(22),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 12,
offset: const Offset(0, 4),
),
],
),
child: Row(
children: [
/// Avatar
Container(
width: 58,
height: 58,
decoration: BoxDecoration(
color: AppColors.light,
shape: BoxShape.circle,
),
child: const Icon(Icons.person, size: 30),
),

const SizedBox(width: 14),

/// INFO
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
student.fullName,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 4),

Text(student.studentIdentifier),

const SizedBox(height: 2),

Text(student.specialization),

const SizedBox(height: 2),

Text('السنة: ${student.year}'),
],
),
),

_statusWidget(student),
],
),
),
);
}

Widget _statusWidget(StudentModel student) {
if (!student.isResident) {
return _badge('غير مقيم', Colors.orange);
}

return _badge('مقيم', Colors.green);
}

Widget _badge(String text, Color color) {
return Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
decoration: BoxDecoration(
color: color.withOpacity(0.15),
borderRadius: BorderRadius.circular(12),
),
child: Text(text),
);
}
}


class StudentsSearchBar extends StatelessWidget {
final TextEditingController controller;
final Function(String) onChanged;

const StudentsSearchBar({
super.key,
required this.controller,
required this.onChanged,
});

@override
Widget build(BuildContext context) {
return TextField(
controller: controller,
onChanged: onChanged,
decoration: InputDecoration(
hintText: 'ابحث عن طالب...',
prefixIcon: const Icon(Icons.search),
filled: true,
fillColor: AppColors.white,
contentPadding: const EdgeInsets.symmetric(vertical: 16),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(18),
borderSide: BorderSide.none,
),
),
);
}
}