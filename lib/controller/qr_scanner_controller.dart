import 'package:get/get.dart';

import '../models/attendance_scan_model.dart';
import '../services/api_service.dart';
import 'attendance_controller.dart';

class QrScannerController extends GetxController {
  final ApiService apiService;

  QrScannerController(this.apiService);

  final AttendanceController attendanceController =
  Get.find<AttendanceController>();

  final RxBool isLoading = false.obs;

  bool _isScanning = false;

  Future<void> scanQr(String qrToken) async {
    if (_isScanning) return;

    _isScanning = true;
    isLoading.value = true;

    try {
      final response = await apiService.post(
        "/supervisor/attendance/scan-qr-code",
        {
          "qr_token": qrToken,
        },
      );

      final result = AttendanceScanResponse.fromJson(response);

      /// تحديث قائمة الطلاب
      await attendanceController.refresh();

      Get.snackbar(
        "نجاح",
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );

      /// الرجوع للشاشة السابقة
      Get.back(result: true);
    } catch (e) {
      _isScanning = false;

      Get.snackbar(
        "خطأ",
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}