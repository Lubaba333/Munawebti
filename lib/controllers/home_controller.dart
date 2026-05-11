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



//////////////////////قال جاهز للربط ///////////////////////////////
/* import 'package:get/get.dart';
import '../../../services/service.dart';

class StudentController extends GetxController {
  final ApiService _api = ApiService();

  var isLoading = false.obs;

  /// 🧠 بيانات الطالبة
  var name = ''.obs;
  var email = ''.obs;
  var studentId = ''.obs;
  var room = ''.obs;

  /// 🏥 بيانات الهوم
  var hospital = ''.obs;
  var time = ''.obs;
  var notifications = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // جاهزة للربط لاحقاً
    // fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      isLoading.value = true;

      final response = await _api.get('/student'); 
      // 👆 غيريه لاحقاً

      name.value = response['name'] ?? '';
      email.value = response['email'] ?? '';
      studentId.value = response['student_id'] ?? '';
      room.value = response['room'] ?? '';

      hospital.value = response['hospital'] ?? '';
      time.value = response['time'] ?? '';
      notifications.value = response['notifications'] ?? 0;

    } catch (e) {
      print("❌ Student Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}*/