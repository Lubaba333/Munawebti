import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';


class StudentsController extends GetxController {
  final searchController = TextEditingController();

  RxBool isLoading = true.obs;

  RxString selectedFilter = 'all'.obs;

  RxList<StudentModel> students =
      <StudentModel>[].obs;

  RxList<StudentModel> filteredStudents =
      <StudentModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadStudents();
  }

  Future<void> loadStudents() async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    students.assignAll([
      StudentModel(
        id: 1,
        name: 'أحمد محمد',
        universityId: '20210015',
        major: 'هندسة معلوماتية',
        room: 'A12',
        status: 'normal',
      ),
      StudentModel(
        id: 2,
        name: 'محمد علي',
        universityId: '20210016',
        major: 'هندسة مدنية',
        room: 'B05',
        status: 'warning',
      ),
      StudentModel(
        id: 3,
        name: 'خالد حسن',
        universityId: '20210017',
        major: 'هندسة معمارية',
        room: 'C02',
        status: 'violation',
      ),
    ]);

    filteredStudents.assignAll(students);

    isLoading.value = false;
  }

  void searchStudents(String value) {
    final query = value.toLowerCase();

    filteredStudents.assignAll(
      students.where(
            (student) =>
        student.name
            .toLowerCase()
            .contains(query) ||
            student.universityId
                .contains(query),
      ),
    );
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;

    if (filter == 'all') {
      filteredStudents.assignAll(students);
      return;
    }

    filteredStudents.assignAll(
      students.where(
            (student) =>
        student.status == filter,
      ),
    );
  }
}