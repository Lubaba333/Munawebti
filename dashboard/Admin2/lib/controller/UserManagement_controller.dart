import 'package:get/get.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';

class UserManagementController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;
  var filter = "Students".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// =========================
  /// جلب قائمة المستخدمين
  /// =========================
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      String endpoint = filter.value == "Supervisors" ? '/admin/supervisors' : '/admin/students';

      final response = await _apiService.get(endpoint);

      if (response['data'] != null && response['data']['data'] != null) {
        List data = response['data']['data'];
        String currentRole = filter.value == "Supervisors" ? "Supervisor" : "Student";

        users.assignAll(data.map((e) => UserModel.fromJson(e, currentRole)).toList());
      }
    } catch (e) {
      Get.snackbar("Fetch error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================================
  /// حفظ المستخدم (إضافة أو تعديل) - حل مشكلة 422
  /// ==========================================
  Future<void> saveUser(UserModel user, {bool isEdit = false}) async {
    try {
      isLoading.value = true;

      // تحديد المسار الصحيح بناءً على الدور
      String type = user.role == "Student" ? 'students' : 'supervisors';
      String endpoint = isEdit ? '/admin/$type/${user.id}' : '/admin/$type';

      // تحويل الكائن إلى Map
      Map<String, dynamic> data = user.toJson();

      if (isEdit) {
        // 💡 هذه الإضافة هي الأهم لنجاح التعديل في لارافل
        data["_method"] = "PUT";
      }

      // نستخدم دالة post دائماً ونضع _method بالداخل
      final response = await _apiService.post(endpoint, data);

      if (response != null) {
        await fetchUsers(); // تحديث القائمة
        Get.back(); // إغلاق الواجهة
        Get.snackbar("success", isEdit ? "Data has been updated" : "User added");
      }
    } catch (e) {
      print("❌ Update/Add Error: $e");
      // إظهار رسالة الخطأ لمعرفة أي حقل فشل فيه الـ Validation
      Get.snackbar("Operation failed", "Make sure the fields are correct:$e");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// تبديل حالة الحظر (Block)
  /// =========================
  Future<void> toggleBlock(UserModel user) async {
    try {
      String type = user.role == "Student" ? 'students' : 'supervisors';
      String action = user.isBlocked ? 'unblock' : 'block';

      // إرسال طلب الحظر/إلغاء الحظر
      final response = await _apiService.post('/admin/$type/${user.id}/$action', {});

      if (response != null) {
        await fetchUsers(); // تحديث الحالة في الواجهة
        Get.snackbar("Status update", "The ban status has been successfully changed.");
      }
    } catch (e) {
      Get.snackbar("Erorr", "The ban status change failed: $e");
    }
  }

  /// =========================
  /// حذف مستخدم
  /// =========================
  Future<void> deleteUser(int id) async {
    try {
      String type = filter.value == "Supervisors" ? 'supervisors' : 'students';
      final response = await _apiService.delete('/admin/$type/$id');

      if (response != null) {
        users.removeWhere((u) => u.id == id);
        Get.snackbar("Delet", "The user has been deleted from the system.");
      }
    } catch (e) {
      Get.snackbar("Erorr", "The deletion process could not be completed.");
    }
  }

  /// =========================
  /// تغيير الفلتر (طالبات/مشرفات)
  /// =========================
  void changeFilter(String newFilter) {
    if (filter.value != newFilter) {
      filter.value = newFilter;
      fetchUsers();
    }
  }
}