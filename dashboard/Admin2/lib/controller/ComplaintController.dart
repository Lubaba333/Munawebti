import 'package:get/get.dart';
import '../services/api_service.dart';
import '../model/ComplaintModel.dart';
import '../model/ComplaintDetailModel.dart';
import 'package:flutter/material.dart';
class ComplaintController extends GetxController {
  final ApiService api = Get.find();

  var isLoading = false.obs;
  var selectedStatus = "reviewed".obs;
  var complaints = <ComplaintModel>[].obs;
  var selectedComplaint = Rxn<ComplaintDetailModel>();

  // ================= GET ALL =================
  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;

      final response = await api.get('/admin/housing-complaints');

      final List data = response['data']['data'] ?? [];

      complaints.value =
          data.map((e) => ComplaintModel.fromJson(e)).toList();

    } catch (e) {
      print("COMPLAINTS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SHOW ONE =================
  Future<void> fetchComplaintDetails(int id) async {
    try {
      isLoading.value = true;

      final response = await api.get('/admin/housing-complaints/$id');

      selectedComplaint.value =
          ComplaintDetailModel.fromJson(response['data']);

    } catch (e) {
      print("DETAIL ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= RESPOND =================
  Future<void> respondComplaint(int id, String responseText) async {
    try {
      final res = await api.put(
        '/admin/housing-complaints/$id/response',
        {
          'admin_response': responseText,
          'status': 'reviewed',
        },
      );

      print("✅ RESPONSE SUCCESS: $res");
      Get.snackbar(
        "Success",
        "Response sent successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchComplaintDetails(id);
      fetchComplaints();

    } catch (e) {
      print("❌ RESPONSE ERROR: $e");
    }
  }

  // ================= UPDATE =================
  Future<void> updateComplaint(int id, String status) async {
    try {
      isLoading.value = true;

      await api.put(
        '/admin/housing-complaints/$id/status',
        {
          "status": status,
        },
      );

      await fetchComplaintDetails(id);
      await fetchComplaints();

    } catch (e) {
      print("UPDATE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}