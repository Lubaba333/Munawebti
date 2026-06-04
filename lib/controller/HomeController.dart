import 'package:get/get.dart';

import 'AuthController.dart';

class HomeController extends GetxController {

  final authController =
      Get.find<AuthController>();

  var isLoading = false.obs;

  String get userName =>
      authController
          .supervisor
          .value
          ?.fullName ??
      "";

  var currentShift = {
    "title": "Hospital",
    "type": "Morning",
    "time": "08:00 - 02:00",
    "status": "active"
  }.obs;

  var todaySchedule =
      <Map<String, String>>[].obs;

  var notifications = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {

    isLoading.value = true;

    Future.delayed(
      Duration(seconds: 1),
      () {

        todaySchedule.value = [
          {
            "time": "08:00 - 02:00",
            "place": "Hospital"
          },
          {
            "time": "03:00 - 08:00",
            "place": "Dorm"
          },
        ];

        notifications.value = [
          "Swap request approved",
          "New message from admin",
        ];

        isLoading.value = false;
      },
    );
  }
}