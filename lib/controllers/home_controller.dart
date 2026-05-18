import 'package:get/get.dart';

class HomeController extends GetxController {

  /// 👩 اسم الطالبة
  var studentName = "".obs;

  /// 🏥 بيانات الكارد
  var hospital = "".obs;
  var time = "".obs;

  /// 🔔 عدد الإشعارات
  var notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    loadMockData();
  }

  void loadMockData() {
    studentName.value = "Lina Ahmed";

    hospital.value = "مشفى الجامعة";
    time.value = "08:00 AM";

    notificationCount.value = 3; // 🔴 للتجربة
  }
}