import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studants/services/service.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var notifications = <dynamic>[].obs;
  var unreadNotificationsCount = 0.obs;

  int _lastSeenId = 0;

  @override
  void onInit() {
    super.onInit();
    _loadLastSeenId();
    getNotifications();
  }

  Future<void> _loadLastSeenId() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSeenId = prefs.getInt('last_seen_notification_id') ?? 0;
  }

  Future<void> _saveLastSeenId(int id) async {
    _lastSeenId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_seen_notification_id', id);
  }

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/notifications',
        authRequired: true,
      );

      final data = response['data']?['data'];

      if (data is List) {
        notifications.value = data;

        // 🔥 نحسب الغير مقروء اعتمادًا على الـ id مو على read_at
        // (بسبب باغ بالباك اند بيعلّم read_at تلقائيًا بالغلط)
        unreadNotificationsCount.value =
            data.where((n) => (n['id'] as int) > _lastSeenId).length;
      } else {
        notifications.clear();
        unreadNotificationsCount.value = 0;
      }
    } catch (e) {
      print("Notification Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// استدعاء عند دخول صفحة الإشعارات
  Future<void> markAllAsRead() async {
    await getNotifications();

    if (notifications.isNotEmpty) {
      final maxId = notifications
          .map((n) => n['id'] as int)
          .reduce((a, b) => a > b ? a : b);
      await _saveLastSeenId(maxId);
    }

    unreadNotificationsCount.value = 0;
  }

  void increaseUnreadCount() {
    unreadNotificationsCount.value++;
  }

  void clearUnreadCount() {
    unreadNotificationsCount.value = 0;
  }
}