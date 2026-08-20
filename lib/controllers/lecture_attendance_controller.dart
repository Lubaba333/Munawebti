import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studants/services/service.dart';

class LectureAttendanceController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isCheckingIn = false.obs;
  var isCancelling = false.obs;

  var upcomingLecture = Rxn<Map<String, dynamic>>();
  var attendanceHistory = <Map<String, dynamic>>[].obs;
  var qrToken = ''.obs;
  var isCheckedIn = false.obs;
  var checkInTime = ''.obs;
  var checkInAt = ''.obs;
  var attendanceRecorded = false.obs;
  var errorMessage = ''.obs;

  var qrCreatedAt = Rxn<DateTime>();
  var isQrExpired = false.obs;
  Timer? _expiryTimer;

  static const String _qrCreatedAtKey = 'qr_created_at';
  static const String _qrTokenKey = 'qr_token';
  static const String _isCheckedInKey = 'is_checked_in';

  @override
  void onInit() {
    super.onInit();
    _restoreQrState();
  }

  Future<void> _restoreQrState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedQrCreatedAt =
          prefs.getString(_qrCreatedAtKey);

      final savedQrToken =
          prefs.getString(_qrTokenKey);

      final savedIsCheckedIn =
          prefs.getBool(_isCheckedInKey) ?? false;

      if (savedQrCreatedAt != null &&
          savedQrToken != null &&
          savedIsCheckedIn) {
        final createdAt = DateTime.parse(savedQrCreatedAt);
        final elapsed =
            DateTime.now().difference(createdAt);

        if (elapsed < const Duration(hours: 3)) {
          qrCreatedAt.value = createdAt;
          qrToken.value = savedQrToken;
          isCheckedIn.value = savedIsCheckedIn;
          startQrTimer();
        } else {
          isQrExpired.value = true;
          qrCreatedAt.value = createdAt;
          qrToken.value = savedQrToken;
          isCheckedIn.value = savedIsCheckedIn;
        }
      }
    } catch (e) {
      print("❌ ${"restore_barcode_error".tr}: $e");
    }
  }

  Future<void> _saveQrState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (qrCreatedAt.value != null) {
        await prefs.setString(
          _qrCreatedAtKey,
          qrCreatedAt.value!.toIso8601String(),
        );
      }

      if (qrToken.value.isNotEmpty) {
        await prefs.setString(
          _qrTokenKey,
          qrToken.value,
        );
      }

      await prefs.setBool(
        _isCheckedInKey,
        isCheckedIn.value,
      );
    } catch (e) {
      print("❌ ${"save_barcode_state_error".tr}: $e");
    }
  }

  Future<void> _clearQrState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_qrCreatedAtKey);
      await prefs.remove(_qrTokenKey);
      await prefs.remove(_isCheckedInKey);
    } catch (e) {
      print("❌ ${"clear_barcode_state_error".tr}: $e");
    }
  }

  /// [forceReset] لما تكون true بتجبر تصفير وقت الإنشاء للحظة الحالية،
  /// حتى لو كان فيه وقت قديم متخزن مسبقاً (مثلاً من تسجيل حضور سابق
  /// منتهي). هاد ضروري عند كل تسجيل حضور جديد فعلي.
  void startQrTimer({bool forceReset = false}) {
    if (forceReset || qrCreatedAt.value == null) {
      qrCreatedAt.value = DateTime.now();
    }

    isQrExpired.value = false;
    _expiryTimer?.cancel();

    _expiryTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (qrCreatedAt.value == null) return;

        final elapsed =
            DateTime.now().difference(qrCreatedAt.value!);

        if (elapsed >= const Duration(hours: 3)) {
          isQrExpired.value = true;
          _expiryTimer?.cancel();
        }
      },
    );
  }

  void stopQrTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }

  @override
  void onClose() {
    stopQrTimer();
    super.onClose();
  }

  Future<void> getUpcomingLecture() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _apiService.get(
        '/student/attendance/upcoming-shift',
        queryParameters: {
          'shift_type': 'lecture',
        },
        authRequired: true,
      );

      if (res == null) {
        throw Exception("empty_response".tr);
      }

      final shiftData = res['data']?['shift'];
      final shiftDetails = res['data']?['shift_details'];
      final checkInStatus = res['data']?['check_in_status'];

      if (shiftData == null) {
        upcomingLecture.value = null;
        errorMessage.value = 'no_upcoming_lectures'.tr;
        return;
      }

      if (checkInStatus != null) {
        isCheckedIn.value =
            checkInStatus['checked_in'] ?? false;

        checkInAt.value =
            checkInStatus['check_in_at'] ?? '';

        attendanceRecorded.value =
            checkInStatus['attendance_recorded'] ?? false;

        if (attendanceRecorded.value) {
          await _clearQrState();
        }
      }

      upcomingLecture.value = {
        ...Map<String, dynamic>.from(shiftData as Map),
        if (shiftDetails != null)
          ...Map<String, dynamic>.from(
            shiftDetails as Map,
          ),
      };
    } catch (e) {
      errorMessage.value =
          e.toString().replaceAll('Exception:', '').trim();

      upcomingLecture.value = null;

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
        {
          "shift_id": shiftId,
        },
        authRequired: true,
      );

      if (res['data'] != null &&
          res['data']['qr_token'] != null) {
        qrToken.value = res['data']['qr_token'];
      }

      isCheckedIn.value = true;
      checkInTime.value = DateTime.now().toString();

      // ✅ الإصلاح: هاد تسجيل حضور جديد فعلياً، فلازم نصفّر وقت الإنشاء
      // للحظة الحالية دايماً - حتى لو كان فيه وقت قديم (منتهي) متخزن
      // من قبل بالـ SharedPreferences. بدون forceReset، كان الكود
      // يتجاهل تحديث الوقت لأنو الشرط كان "إذا كانت null بس"، فكان
      // الـ QR الجديد يورث تاريخ الانتهاء القديم ويطلع "منتهي" بعد ثانية.
      startQrTimer(forceReset: true);

      await _saveQrState();
      await getUpcomingLecture();

      Get.snackbar(
        "success".tr,
        "show_qr_to_supervisor".tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      String errorMsg =
          e.toString().replaceAll('Exception:', '').trim();

      if (errorMsg.contains(
            'Check-in is only allowed before the shift starts',
          ) ||
          errorMsg
              .toLowerCase()
              .contains('before the shift starts')) {
        errorMsg =
            "check_in_only_before_lecture".tr;
      } else if (errorMsg.toLowerCase().contains('24 hours') ||
          errorMsg.contains('قبل')) {
        errorMsg =
            "cannot_check_in_before_24_hours".tr;
      }

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
      qrCreatedAt.value = null;
      isQrExpired.value = false;

      stopQrTimer();
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
          'shift_type': 'lecture',
        },
        authRequired: true,
      );

      if (res['data'] != null &&
          res['data']['data'] != null) {
        final all =
            List<Map<String, dynamic>>.from(
          res['data']['data'] ?? [],
        );

        attendanceHistory.value =
            all.where(
          (r) => r['shift_type'] == 'lecture',
        ).toList();
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
    qrCreatedAt.value = null;
    isQrExpired.value = false;

    stopQrTimer();
    await _clearQrState();
  }

  bool get hasUpcomingLecture =>
      upcomingLecture.value != null;
}