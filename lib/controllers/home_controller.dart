import 'package:get/get.dart';

class HomeController extends GetxController {
  var studentName = "Ghaeda".obs;
  var hospital = "مستشفى الجامعة".obs;
  var time = "08:00 AM".obs;
  var notificationCount = 3.obs;

  /// 🔥 أضف هذول (كانوا سبب الخطأ)
  var isDarkMode = false.obs;
  var selectedLanguage = "العربية".obs;
}