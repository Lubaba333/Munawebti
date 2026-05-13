import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/WarningModel.dart';
import '../model/user_model.dart';

import '../services/api_service.dart';

class WarningsController extends GetxController {
  final UserModel user;

  WarningsController({required this.user});

  final ApiService api = Get.find<ApiService>();

  /// ================= STATE =================
  var isLoading = false.obs;
  var warnings = <WarningModel>[].obs;

  /// ================= CONTROLLERS =================
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final penaltyController = TextEditingController();

  /// لازم تكون قيمة موجودة دائماً
  var targetType = "student".obs;

  @override
  void onInit() {
    super.onInit();
    getWarnings();
  }

  /// ================= GET WARNINGS =================
  Future<void> getWarnings() async {
    try {
      isLoading.value = true;

      final response = await api.get(
        "/admin/warnings",
        queryParameters: {
          // فلترة حسب المستخدم (اختياري حسب الباك إند عندك)
          if (user.role == "student")
            "student_id": user.id.toString(),

          if (user.role == "supervisor")
            "supervisor_id": user.id.toString(),
        },
      );

      final List data = response['data']['data'] ?? [];

      warnings.value =
          data.map((e) => WarningModel.fromJson(e)).toList();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= CREATE WARNING =================
  Future<void> createWarning() async {
    try {
      await api.post(
        "/admin/warnings",
        {
          "target_type": targetType.value,
          "target_id": user.id,
          "title": titleController.text,
          "description": descriptionController.text,
          "warning_date": dateController.text,
          "possible_penalty": penaltyController.text,
        },
      );

      clearFields();
      getWarnings();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// ================= UPDATE WARNING =================
  Future<void> updateWarning(int id) async {
    try {
      await api.put(
        "/admin/warnings/$id",
        {
          "title": titleController.text,
          "description": descriptionController.text,
          "warning_date": dateController.text,
          "possible_penalty": penaltyController.text,
        },
      );

      clearFields();
      getWarnings();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// ================= DELETE WARNING =================
  Future<void> deleteWarning(int id) async {
    try {
      await api.delete("/admin/warnings/$id");
      getWarnings();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// ================= CLEAR =================
  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    penaltyController.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    penaltyController.dispose();
    super.onClose();
  }
}