import 'package:get/get.dart';
import 'package:studants/services/service.dart';

class WarningDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var warning = {}.obs;

  final int id;

  WarningDetailsController(this.id);

  @override
  void onInit() {
    getDetails();
    super.onInit();
  }

  Future<void> getDetails() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/warnings/$id',
        authRequired: true,
      );

      print("📥 Warning Details: $response");

      if (response['data'] != null) {
        warning.value = Map<String, dynamic>.from(response['data']);
      }

    } catch (e) {
      print("❌ Details Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}