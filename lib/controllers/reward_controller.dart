import 'package:get/get.dart';
import 'package:studants/models/reward_model.dart';
import 'package:studants/services/service.dart';

class RewardController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var rewards = <RewardModel>[].obs;

  @override
  void onInit() {
    getRewards();
    super.onInit();
  }

  /// 📥 جلب المكافآت
  Future<void> getRewards() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/rewards',
        authRequired: true,
      );

      print("📥 Rewards Response: $response");

      final data = response['data'];

      if (data is List) {
        rewards.value =
            data.map((e) => RewardModel.fromJson(e)).toList();
      } else if (data is Map && data['data'] is List) {
        rewards.value =
            (data['data'] as List)
                .map((e) => RewardModel.fromJson(e))
                .toList();
      } else {
        rewards.value = [];
      }

    } catch (e) {
      print("❌ Rewards Error: $e");
      rewards.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}