// lib/controllers/emergency_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/EmergencyCase.dart';
import '../services/service.dart';

class EmergencyController extends GetxController {
  final ApiService _api = ApiService();

  var isLoading = false.obs;
  var emergencyCases = <EmergencyCase>[].obs;
  var selectedCase = Rxn<EmergencyCase>();
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmergencyCases();
  }

  /// 📡 GET /student/emergency-cases
  Future<void> fetchEmergencyCases({int page = 1}) async {
    isLoading.value = true;
    try {
      print("📡 Fetching emergency cases (page: $page)...");
      
      final response = await _api.get(
        '/student/emergency-cases',
        queryParameters: {'per_page': 15, 'page': page},
      );

      print("✅ Response Received: $response");

      final responseData = response['data'];
      
      if (responseData == null) {
        emergencyCases.clear();
        return;
      }

      List<Map<String, dynamic>> casesList = [];

      // ✅ الحالة 1: البيانات داخل Pagination (Laravel style)
      if (responseData is Map && responseData['data'] != null) {
        // ✅ casting صحيح للقائمة الداخلية
        final innerData = responseData['data'];
        if (innerData is List) {
          casesList = innerData
              .map((e) => (e as Map).cast<String, dynamic>())
              .toList();
        }
        totalPages.value = responseData['last_page'] ?? 1;
        currentPage.value = responseData['current_page'] ?? 1;
      }
      // ✅ الحالة 2: البيانات قائمة مباشرة
      else if (responseData is List) {
        casesList = responseData
            .map((e) => (e as Map).cast<String, dynamic>())
            .toList();
        totalPages.value = 1;
        currentPage.value = 1;
      }

      // ✅ تحويل البيانات إلى موديلات
      emergencyCases.value = casesList
          .map((e) => EmergencyCase.fromJson(e))
          .toList();

      print("✅ Loaded ${emergencyCases.length} cases");

    } catch (e) {
      print("❌ Error fetching emergency cases: $e");
      
      Get.snackbar(
        'error'.tr, 
        '${'failed_fetch_emergency_data'.tr}: $e', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 📡 GET /student/emergency-cases/{id}
  Future<void> fetchCaseDetails(int id) async {
    isLoading.value = true;
    try {
      final response = await _api.get('/student/emergency-cases/$id');
      
      final data = response['data'];
      if (data != null) {
        // ✅ إذا كان داخل Pagination wrapper
        if (data is Map && data['data'] != null) {
          final innerData = data['data'];
          if (innerData is Map) {
            selectedCase.value = EmergencyCase.fromJson(
              innerData.cast<String, dynamic>(),
               // ✅ casting هنا
            );
            // في دالة fetchCaseDetails
print("🔍 Raw JSON for case $id: $data");
          }
        } 
        // ✅ إذا كان الموديل مباشرة
        else if (data is Map) {
          selectedCase.value = EmergencyCase.fromJson(
            data.cast<String, dynamic>(), // ✅ casting هنا
          );
        }
      }
    } catch (e) {
      Get.snackbar('error'.tr, '${'failed_fetch_report_details'.tr}: ${e.toString()}', 
        snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// 📡 POST /student/emergency-cases
  Future<void> submitEmergencyCase({
    required String title,
    required String description,
    required String severity,
  }) async {
    isLoading.value = true;
    try {
      final body = {
        'title': title,
        'description': description,
        'severity': severity,
      };
      
      await _api.post('/student/emergency-cases', body);
      
      Get.back();
      Get.snackbar('success'.tr, 'report_sent'.tr, 
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      fetchEmergencyCases(page: 1);
      
    } catch (e) {
      Get.snackbar('report_failed'.tr, e.toString(), 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}