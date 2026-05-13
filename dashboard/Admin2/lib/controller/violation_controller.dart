import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/ViolationModel.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';

class ViolationsController extends GetxController {
  final UserModel user;
  final ApiService apiService = ApiService();

  ViolationsController({required this.user});

  RxBool isLoading = false.obs;
  RxList<ViolationModel> violations = <ViolationModel>[].obs;

  RxString targetType = "student".obs;

  /// Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController penaltyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  int get targetId => user.id!;

  @override
  void onInit() {
    super.onInit();
    getViolations();
  }

  /// ================= GET =================
  Future<void> getViolations() async {
    try {
      isLoading.value = true;

      print("📥 GET VIOLATIONS FOR USER: ${user.id}");

      final response = await apiService.get('/admin/violations');

      print("📥 RESPONSE: $response");

      final data = response['data']['data'] as List;

      violations.value =
          data.map((e) => ViolationModel.fromJson(e)).toList();

      print("✅ VIOLATIONS COUNT: ${violations.length}");
    } catch (e) {
      print("❌ GET VIOLATIONS ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= CREATE =================
  Future<void> createViolation() async {
    try {
      isLoading.value = true;

      final body = {
        "target_type": targetType.value,
        "target_id": targetId,
        "title": titleController.text,
        "description": descriptionController.text,
        "violation_date": dateController.text,
        "category": categoryController.text,
        "penalty": penaltyController.text,
      };

      print("📤 CREATE VIOLATION BODY: $body");

      await apiService.post('/admin/violations', body);

      Get.snackbar(
        "Success",
        "Violation created",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
      getViolations();
    } catch (e) {
      print("❌ CREATE VIOLATION ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateViolation(int id) async {
    try {
      isLoading.value = true;

      final body = {
        "target_type": targetType.value,
        "title": titleController.text,
        "description": descriptionController.text,
        "violation_date": dateController.text,
        "category": categoryController.text,
        "penalty": penaltyController.text,
      };

      print("📤 UPDATE VIOLATION ID: $id");
      print("📤 BODY: $body");

      await apiService.post(
        '/admin/violations/$id',
        {
          ...body,
          "_method": "PUT",
        },
      );

      Get.snackbar(
        "Success",
        "Violation updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
      getViolations();

    } catch (e) {
      print("❌ UPDATE VIOLATION ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  /// ================= DELETE =================
  Future<void> deleteViolation(int id) async {
    try {
      isLoading.value = true;

      await apiService.delete('/admin/violations/$id');

      violations.removeWhere((e) => e.id == id);

      Get.snackbar(
        "Deleted",
        "Violation removed",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ DELETE ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    penaltyController.clear();
    dateController.clear();
    categoryController.clear();
  }
}