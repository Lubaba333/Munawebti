import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/services/api_service.dart';


class StudentsController extends GetxController {
  final ApiService _api = ApiService();

  final searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxString selectedFilter = 'all'.obs;

  RxList<StudentModel> students = <StudentModel>[].obs;
  RxList<StudentModel> filteredStudents = <StudentModel>[].obs;

  int currentPage = 1;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  Future<void> loadStudents({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage = 1;
        students.clear();
        hasMore = true;
      }

      isLoading.value = true;

      final response = await _api.get(
        '/supervisor/students',
        queryParameters: {
          'page': currentPage.toString(),
        },
      );

      final data = response['data'];

      final List list = data['data'];

      final newStudents =
      list.map((e) => StudentModel.fromJson(e)).toList();

      students.addAll(newStudents);

      filteredStudents.assignAll(students);

      currentPage = data['current_page'] + 1;
      hasMore = data['next_page_url'] != null;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }




  void changeFilter(String filter) {
    selectedFilter.value = filter;

    if (filter == 'all') {
      filteredStudents.assignAll(students);
    }
    else if (filter == 'resident') {
      filteredStudents.assignAll(
        students.where((s) => s.isResident),
      );
    }
    else if (filter == 'non_resident') {
      filteredStudents.assignAll(
        students.where((s) => !s.isResident),
      );
    }
  }




  void searchStudents(String value) {
    final query = value.toLowerCase();

    if (query.isEmpty) {
      filteredStudents.assignAll(students);
      return;
    }

    filteredStudents.assignAll(
      students.where(
            (student) =>
        student.fullName.toLowerCase().contains(query) ||
            student.studentIdentifier.contains(query) ||
            student.email.toLowerCase().contains(query),
      ),
    );
  }
}