import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../services/api_service.dart';


class NotificationsController extends GetxController {
  final ApiService _api = ApiService();

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final unreadCount = 0.obs;

  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(refresh: true);
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      notifications.clear();
    }

    try {
      isLoading.value = true;

      final response = await _api.get(
        '/supervisor/notifications',
        queryParameters: {'page': _currentPage},
      );

      if (response['status_code'] == 200) {
        final data = response['data'];
        _lastPage = data['last_page'];

        final List rawList = data['data'];
        final items =
        rawList.map((e) => NotificationModel.fromJson(e)).toList();

        notifications.addAll(items);
        _updateUnreadCount();
      }
    } catch (e) {
      print("❌ NOTIFICATIONS FETCH ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_currentPage >= _lastPage || isLoadingMore.value) return;
    isLoadingMore.value = true;
    _currentPage++;
    await fetchNotifications();
    isLoadingMore.value = false;
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  /// يستدعى عند وصول إشعار جديد وقت التطبيق مفتوح (من main.dart)
  void incrementUnreadLocally() {
    unreadCount.value++;
  }

}