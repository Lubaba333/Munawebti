import 'package:get/get.dart';
import 'package:studants/models/warning_model.dart';
import 'package:studants/services/service.dart';

class WarningController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var warnings = <WarningModel>[].obs;

  @override
  void onInit() {
    getWarnings();
    super.onInit();
  }

  /// 📥 جلب كل التحذيرات
  Future<void> getWarnings() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/warnings',
        authRequired: true,
      );

      print("📥 Warnings Response: $response");

      final data = response['data'];

      if (data is List) {
        warnings.value =
            data.map((e) => WarningModel.fromJson(e)).toList();
      } else if (data is Map && data['data'] is List) {
        warnings.value =
            (data['data'] as List)
                .map((e) => WarningModel.fromJson(e))
                .toList();
      } else {
        warnings.value = [];
      }

    } catch (e) {
      print("❌ Warning Error: $e");
      warnings.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}