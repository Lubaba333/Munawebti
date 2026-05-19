import 'package:get/get.dart';
import 'package:studants/services/service.dart';

class RewardDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var reward = {}.obs;

  final int id;

  RewardDetailsController(this.id);

  @override
  void onInit() {
    getDetails();
    super.onInit();
  }

  Future<void> getDetails() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/rewards/$id',
        authRequired: true,
      );

      print("📥 Reward Details: $response");

      if (response['data'] != null) {
        reward.value = Map<String, dynamic>.from(response['data']);
      }

    } catch (e) {
      print("❌ Details Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}