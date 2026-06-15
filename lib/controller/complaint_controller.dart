import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/housing_complaint_model.dart';

class ComplaintController extends GetxController {
  final ApiService apiService;

  ComplaintController(this.apiService);

  var complaints = <HousingComplaint>[].obs;
  var isLoading = false.obs;

  /// 🔵 GET ALL COMPLAINTS
  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;

      final response = await apiService.get(
        '/supervisor/housing-complaints',
      );

      final List data = response['data']['data'];

      complaints.value =
          data.map((e) => HousingComplaint.fromJson(e)).toList();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🟢 CREATE COMPLAINT
  Future<void> createComplaint({
    required int studentId,
    required String title,
    required String description,
    required String complaint_type,
  }) async {
    try {
      await apiService.post(
        '/supervisor/housing-complaints',
        {
          "student_id": studentId,
          "complaint_type": complaint_type,
          "title": title,
          "description": description,
        },
      );

      await fetchComplaints();
      Get.back();

      Get.snackbar("Success", "Complaint created successfully");

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// 🔵 GET SINGLE COMPLAINT
  Future<HousingComplaint> getComplaintById(int id) async {
    final response = await apiService.get(
      '/supervisor/housing-complaints/$id',
    );

    return HousingComplaint.fromJson(response['data']);
  }

  @override
  void onInit() {
    fetchComplaints();
    super.onInit();
  }
}