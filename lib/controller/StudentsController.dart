import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/services/api_service.dart';

class StudentsController extends GetxController {
  final ApiService _api = ApiService();

  final TextEditingController searchController =
  TextEditingController();

  final RxBool isLoading = false.obs;

  final RxBool isLoadingMore = false.obs;

  final RxString selectedFilter = 'all'.obs;

  final RxString selectedYear = 'all'.obs;

  final RxList<StudentModel> students =
      <StudentModel>[].obs;

  final RxList<StudentModel> filteredStudents =
      <StudentModel>[].obs;

  int currentPage = 1;

  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();

    loadStudents(refresh: true);
  }

  // =========================================================
  // LOAD ALL STUDENTS
  // =========================================================

  Future<void> loadStudents({
    bool refresh = false,
  }) async {
    if (isLoading.value || isLoadingMore.value) {
      return;
    }

    try {
      if (refresh) {
        currentPage = 1;
        hasMore = true;

        students.clear();
        filteredStudents.clear();

        isLoading.value = true;
      } else {
        if (!hasMore) return;

        isLoadingMore.value = true;
      }

      while (hasMore) {
        print("Loading students page: $currentPage");

        final response = await _api.get(
          '/supervisor/students',
          queryParameters: {
            'page': currentPage.toString(),
          },
        );

        final data = response['data'];

        final List list = data['data'] ?? [];

        final List<StudentModel> newStudents =
        list
            .map(
              (e) => StudentModel.fromJson(e),
        )
            .toList();

        students.addAll(newStudents);

        print(
          "Page $currentPage loaded: "
              "${newStudents.length} students",
        );

        print(
          "Total loaded: ${students.length}",
        );

        final nextPageUrl =
        data['next_page_url'];

        if (nextPageUrl == null) {
          hasMore = false;

          print("All students loaded.");
        } else {
          currentPage++;

          // مهم جداً لمنع 429
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
        }
      }

      applyFilters();

      print(
        "FINAL STUDENTS COUNT = ${students.length}",
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // =========================================================
  // SEARCH
  // =========================================================

  void searchStudents(String value) {
    applyFilters();
  }

  // =========================================================
  // CHANGE RESIDENCY FILTER
  // =========================================================

  void changeFilter(String filter) {
    selectedFilter.value = filter;

    applyFilters();
  }

  // =========================================================
  // CHANGE YEAR
  // =========================================================

  void changeYear(String year) {
    selectedYear.value = year;

    applyFilters();
  }

  // =========================================================
  // APPLY ALL FILTERS
  // =========================================================

  void applyFilters() {
    List<StudentModel> temp =
    List<StudentModel>.from(students);

    // -------------------------------------------------------
    // SEARCH
    // -------------------------------------------------------

    final query =
    searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      temp = temp.where((student) {
        return student.fullName
            .toLowerCase()
            .contains(query) ||
            student.studentIdentifier
                .toLowerCase()
                .contains(query) ||
            student.email
                .toLowerCase()
                .contains(query);
      }).toList();
    }

    // -------------------------------------------------------
    // RESIDENT FILTER
    // -------------------------------------------------------

    if (selectedFilter.value == 'resident') {
      temp = temp
          .where(
            (student) => student.isResident,
      )
          .toList();
    }

    if (selectedFilter.value == 'non_resident') {
      temp = temp
          .where(
            (student) => !student.isResident,
      )
          .toList();
    }

    // -------------------------------------------------------
    // YEAR FILTER
    // -------------------------------------------------------

    if (selectedYear.value != 'all') {
      final int? year =
      int.tryParse(selectedYear.value);

      if (year != null) {
        temp = temp
            .where(
              (student) => student.year == year,
        )
            .toList();
      }
    }

    filteredStudents.assignAll(temp);
  }

  // =========================================================
  // REFRESH
  // =========================================================

  Future<void> refreshStudents() async {
    await loadStudents(refresh: true);
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }
}