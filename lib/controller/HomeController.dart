import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  /// 👤 User
  var userName = "Sara".obs;

  /// 🟣 Current Shift
  var currentShift = {
    "title": "Hospital",
    "type": "Morning",
    "time": "08:00 - 02:00",
    "status": "active"
  }.obs;

  /// 📅 Today Schedule
  var todaySchedule = <Map<String, String>>[].obs;

  /// 🔔 Notifications
  var notifications = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      todaySchedule.value = [
        {"time": "08:00 - 02:00", "place": "Hospital"},
        {"time": "03:00 - 08:00", "place": "Dorm"},
      ];

      notifications.value = [
        "Swap request approved",
        "New message from admin",
      ];

      isLoading.value = false;
    });
  }
}