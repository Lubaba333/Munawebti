import 'package:get/get.dart';
import '../models/housing_complaint.dart';
import '../services/service.dart';

class HousingComplaintController extends GetxController {
  final ApiService _api = ApiService();

  var isLoading = false.obs;
  var complaints = <HousingComplaint>[].obs;
  var selectedComplaint = Rxn<HousingComplaint>();

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
  }

  /// 📡 جلب القائمة
  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;

      final response = await _api.get(
        '/student/housing-complaints',
        queryParameters: {
          'per_page': 15,
          'page': 1,
        },
      );

      final data = response['data'];

      if (data is Map && data['data'] != null) {
        complaints.value = (data['data'] as List)
            .map((e) => HousingComplaint.fromJson(e))
            .toList();
      } else {
        complaints.clear();
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 📡 جلب التفاصيل
  Future<void> fetchComplaintDetails(int id) async {
    try {
      isLoading.value = true;

      final response = await _api.get(
        '/student/housing-complaints/$id',
      );

      final data = response['data'];

      if (data != null) {
        selectedComplaint.value =
            HousingComplaint.fromJson(
          data.cast<String, dynamic>(),
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        "failed_load_complaint_details".tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 📡 إنشاء شكوى
  Future<void> createComplaint({
    required String title,
    required String description,
  }) async {
    try {
      isLoading.value = true;

      await _api.post(
        '/student/housing-complaints',
        {
          "title": title,
          "description": description,
        },
      );

      Get.back();

      Get.snackbar(
        "success".tr,
        "complaint_sent".tr,
      );

      fetchComplaints();
    } catch (e) {
      Get.snackbar(
        "error".tr,
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}