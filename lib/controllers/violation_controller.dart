import 'package:get/get.dart';
import 'package:studants/models/violation_model.dart';
import 'package:studants/services/service.dart';

class ViolationController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var violations = <ViolationModel>[].obs;

  @override
  void onInit() {
    getViolations();
    super.onInit();
  }

  /// 📥 جلب كل المخالفات
  Future<void> getViolations() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/violations',
        authRequired: true,
      );

      print("📥 Violations Response: $response");

      final data = response['data'];

      if (data is List) {
        violations.value =
            data.map((e) => ViolationModel.fromJson(e)).toList();
      } else if (data is Map && data['data'] is List) {
        violations.value =
            (data['data'] as List)
                .map((e) => ViolationModel.fromJson(e))
                .toList();
      } else {
        violations.value = [];
      }

    } catch (e) {
      print("❌ Violation Error: $e");
      violations.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}