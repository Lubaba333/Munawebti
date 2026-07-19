import 'package:get/get.dart';
import 'package:studants/services/service.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var notifications = <dynamic>[].obs;

  int get notificationCount => notifications.length;

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/notifications',
        authRequired: true,
      );

      final data = response['data'];

      if (data is List) {
        notifications.value = data;
      } else if (data is Map && data['notifications'] is List) {
        notifications.value = data['notifications'];
      } else if (data is Map && data['data'] is List) {
        notifications.value = data['data'];
      } else {
        notifications.value = [];
      }

      print("✅ Notifications loaded: ${notifications.length}");
      print("📌 Notifications response: $response");
    } catch (e) {
      print("❌ Notifications Error: $e");
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }
}