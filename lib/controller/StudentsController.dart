import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/services/api_service.dart';


class StudentsController extends GetxController {
  final ApiService _api = ApiService();

  final searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxString selectedFilter = 'all'.obs;
  RxString selectedYear = 'all'.obs;

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

      applyFilters();

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
    applyFilters();
  }

  void changeYear(String year) {
    selectedYear.value = year;
    applyFilters();
  }


  void searchStudents(String value) {
    applyFilters();
  }

  void applyFilters() {
    List<StudentModel> temp = List<StudentModel>.from(students);

    // البحث
    final query = searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      temp = temp.where((student) {
        return student.fullName.toLowerCase().contains(query) ||
            student.studentIdentifier.toLowerCase().contains(query) ||
            student.email.toLowerCase().contains(query);
      }).toList();
    }

    // فلترة الإقامة
    if (selectedFilter.value == 'resident') {
      temp = temp.where((s) => s.isResident).toList();
    } else if (selectedFilter.value == 'non_resident') {
      temp = temp.where((s) => !s.isResident).toList();
    }

    // فلترة السنة
    if (selectedYear.value != 'all') {
      temp = temp.where((s) {
        return s.year.toString() == selectedYear.value;
      }).toList();
    }

    filteredStudents.assignAll(temp);
  }
}