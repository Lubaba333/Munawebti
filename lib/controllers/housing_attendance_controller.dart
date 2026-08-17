import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studants/services/service.dart';

class HousingAttendanceController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isCheckingIn = false.obs;
  var isCancelling = false.obs;

  var upcomingShift = Rxn<Map<String, dynamic>>();
  var attendanceHistory = <Map<String, dynamic>>[].obs;
  var qrToken = ''.obs;
  var isCheckedIn = false.obs;
  var checkInTime = ''.obs;
  var checkInAt = ''.obs;
  var attendanceRecorded = false.obs;
  var errorMessage = ''.obs;

  // فقط تخزين بسيط بدون وقت
  static const String _qrTokenKey = 'qr_token_housing';
  static const String _isCheckedInKey = 'is_checked_in_housing';

  @override
  void onInit() {
    super.onInit();
    _restoreQrState();
  }

  Future<void> _restoreQrState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedQrToken = prefs.getString(_qrTokenKey);
      final savedIsCheckedIn = prefs.getBool(_isCheckedInKey) ?? false;

      if (savedQrToken != null && savedIsCheckedIn) {
        qrToken.value = savedQrToken;
        isCheckedIn.value = savedIsCheckedIn;
      }
    } catch (e) {
      debugPrint("❌ ${"restore_qr_error".tr}: $e");
    }
  }

  Future<void> _saveQrState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (qrToken.value.isNotEmpty) {
        await prefs.setString(_qrTokenKey, qrToken.value);
      }
      await prefs.setBool(_isCheckedInKey, isCheckedIn.value);
    } catch (e) {
      debugPrint("❌ ${"save_qr_error".tr}: $e");
    }
  }

  Future<void> _clearQrState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_qrTokenKey);
      await prefs.remove(_isCheckedInKey);
    } catch (e) {
      debugPrint("❌ ${"clear_qr_error".tr}: $e");
    }
  }

  bool get hasUpcomingShift => upcomingShift.value != null;

  Future<void> getUpcomingShift() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _apiService.get(
        '/student/attendance/upcoming-shift',
        queryParameters: {'shift_type': 'housing'},
        authRequired: true,
      );

      final shiftData = res['data']?['shift'];
      final shiftDetails = res['data']?['shift_details'];
      final checkInStatus = res['data']?['check_in_status'];

      if (shiftData == null) {
        upcomingShift.value = null;
        errorMessage.value = 'no_upcoming_housing_shift'.tr;
        return;
      }

      if (checkInStatus != null) {
        isCheckedIn.value = checkInStatus['checked_in'] ?? false;
        checkInAt.value = checkInStatus['check_in_at'] ?? '';
        attendanceRecorded.value =
            checkInStatus['attendance_recorded'] ?? false;

        if (attendanceRecorded.value) {
          await _clearQrState();
        }
      }

      upcomingShift.value = {
        ...Map<String, dynamic>.from(shiftData as Map),
        if (shiftDetails != null)
          ...Map<String, dynamic>.from(shiftDetails as Map),
      };
    } catch (e) {
      errorMessage.value =
          e.toString().replaceAll('Exception:', '').trim();
      upcomingShift.value = null;

      Get.snackbar(
        "error".tr,
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIn(int shiftId) async {
    try {
      isCheckingIn.value = true;

      final res = await _apiService.post(
        '/student/attendance/check-in',
        {"shift_id": shiftId},
        authRequired: true,
      );

      if (res['data'] != null && res['data']['qr_token'] != null) {
        qrToken.value = res['data']['qr_token'];
      }

      isCheckedIn.value = true;
      checkInTime.value = DateTime.now().toString();

      await _saveQrState();
      await getUpcomingShift();

      Get.snackbar(
        "success".tr,
        "show_qr_to_supervisor".tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      String errorMsg =
          e.toString().replaceAll('Exception:', '').trim();

      Get.snackbar(
        "registration_failed".tr,
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCheckingIn.value = false;
    }
  }

  Future<void> cancelCheckIn(int shiftId) async {
    try {
      isCancelling.value = true;

      await _apiService.delete(
        '/student/attendance/check-in/$shiftId',
        authRequired: true,
      );

      isCheckedIn.value = false;
      attendanceRecorded.value = false;
      qrToken.value = '';

      await _clearQrState();

      Get.snackbar(
        "cancelled_successfully".tr,
        "attendance_cancelled_successfully".tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      String errorMsg =
          e.toString().replaceAll('Exception:', '').trim();

      Get.snackbar(
        "cancellation_failed".tr,
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCancelling.value = false;
    }
  }

  Future<void> getAttendanceHistory() async {
    try {
      isLoading.value = true;

      final res = await _apiService.get(
        '/student/attendance/history',
        queryParameters: {
          'per_page': 20,
          'page': 1,
          'shift_type': 'housing',
        },
        authRequired: true,
      );

      if (res['data'] != null && res['data']['data'] != null) {
        final all =
            List<Map<String, dynamic>>.from(res['data']['data'] ?? []);

        attendanceHistory.value =
            all.where((r) => r['shift_type'] == 'housing').toList();
      } else {
        attendanceHistory.value = [];
      }
    } catch (e) {
      attendanceHistory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() async {
    qrToken.value = '';
    isCheckedIn.value = false;
    checkInTime.value = '';
    checkInAt.value = '';
    attendanceRecorded.value = false;

    await _clearQrState();
  }
}