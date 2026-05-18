// lib/controllers/request_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/models/request_model.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/my_requests_view.dart';

class RequestController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var requests = <dynamic>[].obs;

  /// جلب كل طلباتي
  Future<void> getMyRequests() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/requests',
        authRequired: true,
      );

      print("📥 Get Requests Response: $response");

      if (response['data'] != null) {
        if (response['data'] is List) {
          requests.value = response['data'];
        } else if (response['data'] is Map) {
          requests.value = [response['data']];
        } else {
          requests.value = [];
        }
      } else {
        requests.value = [];
      }

      // ✅ طباعة تفاصيل كل طلب للتحقق
      for (var req in requests.value) {
        print("📋 Request - ID: ${req['id']}, Status: ${req['status']}, Title: ${req['title']}");
      }

      print("✅ Requests loaded: ${requests.length} requests");

    } catch (e) {
      print("❌ Get Requests Error: $e");
      requests.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// طلب إذن خروج
  Future<void> createExitRequest(ExitPermissionRequest request) async {
    try {
      isLoading.value = true;

      print("📤 Sending Exit Request: ${request.toJson()}"); // ✅ طباعة البيانات المرسلة

      final response = await _apiService.post(
        '/student/requests',
        request.toJson(),
        authRequired: true,
      );

      print("✅ Exit Request Response: $response");

      Get.snackbar(
        "Success",
        "Exit permission request sent successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      await getMyRequests();
      Get.offAll(MyRequestsView());

    } catch (e) {
      print("❌ Create Exit Request Error: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// طلب تغيير غرفة
  Future<void> createRoomChangeRequest(RoomChangeRequest request) async {
    try {
      isLoading.value = true;

      print("📤 Sending Room Change Request: ${request.toJson()}"); // ✅ طباعة البيانات المرسلة

      final response = await _apiService.post(
        '/student/requests',
        request.toJson(),
        authRequired: true,
      );

      print("✅ Room Change Response: $response");

      Get.snackbar(
        "Success",
        "Room change request sent successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      await getMyRequests();
      Get.back();

    } catch (e) {
      print("❌ Create Room Change Error: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// إلغاء طلب
  Future<void> cancelRequest(int requestId) async {
    try {
      isLoading.value = true;

      print("📤 Cancelling Request ID: $requestId"); // ✅ طباعة ID الطلب الملغى

      final response = await _apiService.delete(
        '/student/requests/$requestId',
        authRequired: true,
      );

      print("✅ Cancel Request Response: $response");

      Get.snackbar(
        "Success",
        "Request cancelled successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      await getMyRequests();

    } catch (e) {
      print("❌ Cancel Request Error: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}