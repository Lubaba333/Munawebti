import 'package:get/get.dart';
import 'package:studants/services/service.dart';

class ViolationDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var violation = {}.obs;

  final int id;

  ViolationDetailsController(this.id);

  @override
  void onInit() {
    getDetails();
    super.onInit();
  }

  Future<void> getDetails() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/violations/$id',
        authRequired: true,
      );

      print("📥 Violation Details: $response");

      if (response['data'] != null) {
        violation.value = Map<String, dynamic>.from(response['data']);
      }

    } catch (e) {
      print("❌ Details Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}