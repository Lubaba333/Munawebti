import 'package:get/get.dart';
import 'package:supervisors/models/housing_complaint_model.dart';
import '../services/api_service.dart';
import 'AuthController.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final ApiService apiService = ApiService();

  var isLoading = false.obs;

  String get userName =>
      authController.supervisor.value?.fullName ?? "";

  var currentShift = {
    "title": "Hospital",
    "type": "Morning",
    "time": "08:00 - 02:00",
    "status": "active"
  }.obs;

  var todaySchedule = <Map<String, String>>[].obs;

  var notifications = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// 🔵 Fake dashboard data
  void loadData() {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      todaySchedule.value = [
        {"time": "08:00 - 02:00", "place": "Hospital"},
        {"time": "03:00 - 08:00", "place": "Dorm"},
      ];

      isLoading.value = false;
    });
  }

  /// 🔵 REAL API CALL (Correct place)
  Future<HousingComplaint> getComplaintById(int id) async {
    try {
      final response = await apiService.get(
        '/supervisor/housing-complaints/$id',
      );

      return HousingComplaint.fromJson(response['data']);
    } catch (e) {
      throw Exception("Failed to load complaint: $e");
    }
  }
}