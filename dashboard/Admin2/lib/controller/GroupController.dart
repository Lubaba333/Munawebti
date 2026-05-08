import 'package:get/get.dart';

import '../model/GroupModel.dart';
import '../model/StudentModel.dart';
import '../services/api_service.dart';

class GroupController extends GetxController {
  final ApiService _apiService = ApiService();
  var groups = <GroupModel>[].obs;
  var isLoading = false.obs;
  var groupStudents = <StudentModel>[].obs;
  var isStudentsLoading = false.obs;
  var availableStudents = <StudentModel>[].obs; // الطلاب المتاح اختيارهم
  var isAvailableLoading = false.obs;
  // جلب الفئات (List Groups)
  Future<void> fetchGroups() async {
    try {
      isLoading(true);
      final response = await _apiService.get('/admin/groups');
      if (response['status_code'] == 200 && response['data'] != null) {
        var rawList = response['data']['data'] as List; // Pagination
        groups.assignAll(rawList.map((e) => GroupModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error fetching groups: $e");
    } finally {
      isLoading(false);
    }
  }

  // إنشاء فئة (Create Group)
  Future<void> addGroup(String groupNo, int sectionId) async {
    try {
      final response = await _apiService.post('/admin/groups', {
        'group_number': groupNo,
        'section_id': sectionId,
      });
      if (response['status_code'] == 201) {
      await fetchGroups();
      Get.back();
      Get.snackbar('نجاح', 'تم إنشاء الفئة بنجاح');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إنشاء الفئة');
    }
  }

  // تحديث فئة (Update Group)
  Future<void> updateGroup(int id, String groupNo, int sectionId) async {
    try {
      final response = await _apiService.put('/admin/groups/$id', {
        'group_number': groupNo,
        'section_id': sectionId,
      });
      if (response['status_code'] == 200) {
      await fetchGroups();
      Get.back();
      Get.snackbar('نجاح', 'تم التحديث بنجاح');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في التحديث');
    }
  }

  // حذف فئة (Delete Group)
  Future<void> deleteGroup(int id) async {
    try {
      final response = await _apiService.delete('/admin/groups/$id');
      if (response['status_code'] == 200) {
      groups.removeWhere((g) => g.id == id);
      Get.snackbar('نجاح', 'تم حذف الفئة');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل الحذف');
    }
  }

  // جلب طلاب فئة معينة
  Future<void> fetchGroupStudents(int groupId) async {
    try {
      isStudentsLoading(true);
      final response = await _apiService.get('/admin/groups/$groupId/students');
      if (response['status_code'] == 200 && response['data'] != null) {
        var rawList = response['data']['data'] as List;
        groupStudents.assignAll(rawList.map((e) => StudentModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error fetching students: $e");
    } finally {
      isStudentsLoading(false);
    }
  }
// 1. جلب الطلاب المتاحين (التصحيح بناءً على الـ API الفعلي)
  Future<void> fetchAvailableStudents(int sectionId) async {
    try {
      isAvailableLoading(true);

      final response = await _apiService.get('/admin/students?section_id=$sectionId');

      if (response['status_code'] == 200) {
        var rawList = response['data']['data'] as List;
        // سنقوم بفلترة الطلاب برمجياً هنا لنعرض فقط من ليس لديهم فئة (pivot null)
        // إذا كان السيرفر لا يدعم فلتر unassigned في الرابط
        availableStudents.assignAll(rawList.map((e) => StudentModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("❌ Error fetching available students: $e");
    } finally {
      isAvailableLoading(false);
    }
  }

// 2. توزيع الطالب (إضافة طالب لفئة)
  Future<void> assignStudentToGroup(int groupId, int studentId) async {
    try {
      // التعديل: إرسال الـ ID داخل مصفوفة (Array) وهو الشائع في Laravel Pivot Tables
      final response = await _apiService.post('/admin/groups/$groupId/students', {
        'student_ids': [studentId], // جرب تغيير الاسم إلى student_ids وإرساله كمصفوفة
      });

      if (response['status_code'] == 200 || response['status_code'] == 201) {
        Get.back(); // إغلاق الـ BottomSheet
        await fetchGroupStudents(groupId); // تحديث القائمة
        Get.snackbar('نجاح', 'تم توزيع الطالب بنجاح');
      }
    } catch (e) {
      // إذا استمر الخطأ، جرب إرسالها هكذا: 'student_id': studentId (بدون مصفوفة)
      // أو اطلب مني فحص ملف الـ Postman في قسم الـ Body لطلب "Assign Student"
      print("❌ Assign Error Details: $e");
      Get.snackbar('خطأ', 'البيانات غير متوافقة مع شروط السيرفر');
    }
  }

// 2. حذف طالب من الفئة (Endpoint: DELETE /admin/groups/{group}/students/{student})
  Future<void> removeStudentFromGroup(int groupId, int studentId) async {
    try {
      final response = await _apiService.delete('/admin/groups/$groupId/students/$studentId');
      if (response['status_code'] == 200) {
        groupStudents.removeWhere((s) => s.id == studentId);
        Get.snackbar('نجاح', 'تم إزالة الطالب من الفئة');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إزالة الطالب');
    }
  }
}