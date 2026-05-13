import 'package:get/get.dart';
import '../model/LectureModel.dart';
import '../services/api_service.dart';

class LectureController extends GetxController {
  final ApiService _apiService = ApiService();

  var lecturesByDay = <String, List<LectureModel>>{}.obs;
  var isLoading = false.obs;

  // جلب المحاضرات
  Future<void> fetchLectures({int year = 1, String specialization = "Computer Science"}) async {
    try {
      isLoading(true);
      final response = await _apiService.get('/admin/lectures?year=$year&specialization=$specialization');

      if (response['status_code'] == 200) {
        var dataMap = response['data']['lectures_by_day'] as Map<String, dynamic>;
        Map<String, List<LectureModel>> formattedData = {};

        dataMap.forEach((day, list) {
          formattedData[day] = (list as List).map((e) => LectureModel.fromJson(e)).toList();
        });

        lecturesByDay.assignAll(formattedData);
      }
    } finally {
      isLoading(false);
    }
  }

  // إضافة محاضرة جديدة
  Future<void> addLecture(Map<String, dynamic> data) async {
    try {
      isLoading(true);
      final response = await _apiService.post('/admin/lectures', data);
      if (response['status_code'] == 201) {
        await fetchLectures();
        Get.back();
        Get.snackbar("نجاح", "تمت إضافة المحاضرة بنجاح");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل في إضافة المحاضرة");
    } finally {
      isLoading(false);
    }
  }

  // --- دالة التحديث (Update) المضافة ---
  Future<void> updateLecture(int id, Map<String, dynamic> data) async {
    try {
      isLoading(true);
      // نمرر الـ ID في الرابط ليعرف السيرفر أي محاضرة سيقوم بتعديلها
      final response = await _apiService.put('/admin/lectures/$id', data);

      if (response['status_code'] == 200) {
        await fetchLectures(); // إعادة جلب البيانات لتحديث الواجهة
        Get.back(); // إغلاق الـ BottomSheet
        Get.snackbar("نجاح", "تم تحديث المحاضرة بنجاح");
      }
    } catch (e) {
      print("Update Error: $e");
      Get.snackbar("خطأ", "فشل في تحديث المحاضرة");
    } finally {
      isLoading(false);
    }
  }

  // حذف محاضرة
  Future<void> deleteLecture(int id) async {
    try {
      final response = await _apiService.delete('/admin/lectures/$id');
      if (response['status_code'] == 200) {
        await fetchLectures();
        Get.snackbar("نجاح", "تم حذف المحاضرة");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الحذف");
    }
  }
}