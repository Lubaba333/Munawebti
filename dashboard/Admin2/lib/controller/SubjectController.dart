import 'package:get/get.dart';
import '../model/SubjectModel.dart';
import '../services/api_service.dart';

class SubjectController extends GetxController {
  final ApiService _apiService = ApiService();
  var subjects = <SubjectModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // سيتم الجلب عند أول مرة يشتغل فيها الكنترولر
    fetchSubjects();
  }

  // دالة مخصصة للريفرش اليدوي أو التلقائي
  Future<void> refreshData() async {
    await fetchSubjects();
  }

  // List: جلب المواد
  Future<void> fetchSubjects() async {
    try {
      isLoading(true);
      final response = await _apiService.get('/admin/subjects');
      if (response['status_code'] == 200 && response['data'] != null) {
        var rawList = response['data']['data'] as List;
        subjects.assignAll(rawList.map((e) => SubjectModel.fromJson(e)).toList());
      }
    } catch (e) {
      _handleApiError(e); // معالجة أخطاء التوكن
    } finally {
      isLoading(false);
    }
  }

  // Create: إضافة مادة
  Future<void> addSubject(String name, bool hasPractical) async {
    try {
      final response = await _apiService.post('/admin/subjects', {
        'name': name,
        'has_practical': hasPractical,
      });
      if (response['status_code'] == 201) {
        await fetchSubjects(); // تحديث القائمة بعد الإضافة
        Get.back();
        Get.snackbar('نجاح', 'تم إنشاء المادة بنجاح');
      }
    } catch (e) {
      _handleApiError(e);
      Get.snackbar('خطأ', 'فشل إنشاء المادة (تأكد من الصلاحيات)');
    }
  }

  // دالة موحدة لمعالجة أخطاء Unauthorized 401
  void _handleApiError(dynamic e) {
    if (e.toString().contains("401")) {
      Get.snackbar('تنبيه', 'انتهت الجلسة أو لا تملك صلاحية');
      // Get.offAllNamed('/login'); // اختياري: توجيه لتسجيل الدخول
    }
    print("❌ API Error: $e");
  }



  // Update: تعديل مادة
  Future<void> updateSubject(int id, String name, bool hasPractical) async {
    try {
      final response = await _apiService.put('/admin/subjects/$id', {
        'name': name,
        'has_practical': hasPractical,
      });
      if (response['status_code'] == 200) {
        fetchSubjects();
        Get.back();
        Get.snackbar('نجاح', 'تم تحديث المادة بنجاح');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل التحديث');
    }
  }

  // Delete: حذف مادة
  Future<void> deleteSubject(int id) async {
    try {
      final response = await _apiService.delete('/admin/subjects/$id');
      if (response['status_code'] == 200) {
        subjects.removeWhere((s) => s.id == id);
        Get.snackbar('نجاح', 'تم حذف المادة بنجاح');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل الحذف');
    }
  }
}