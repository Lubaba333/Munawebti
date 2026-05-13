import 'package:get/get.dart';
import '../model/LectureLocationModel.dart';
import '../services/api_service.dart';

class LocationController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var currentLocation = Rxn<LectureLocationModel>();

  // 1. جلب بيانات الموقع (Show)
  // المسار في البوستمان: /admin/lecture-locations/{{lecture_id}}
  Future<void> fetchLocationDetails(int locationId) async {
    try {
      isLoading(true);
      // تأكد أن الرابط يبدأ بـ / مباشرة
      final response =
      await _apiService.get(
        '/admin/lecture-locations/$locationId',
      );

      if (response['status_code'] == 200) {
        currentLocation.value = LectureLocationModel.fromJson(response['data']);
      } else {
        currentLocation.value = null;
      }
    } catch (e) {
      // هنا نعالج خطأ الـ 404 (No query results)
      currentLocation.value = null;
      print("لا يوجد موقع مسجل لهذه المحاضرة حالياً");
    } finally {
      isLoading(false);
    }
  }

  // 2. إنشاء موقع (Store)
  Future<void> createLocation(int lectureId, String labName) async {
    try {

      final response = await _apiService.post(
        '/admin/lecture-locations/$lectureId',
        {
          'lab_name': labName,
        },
      );

      if (response['status_code'] == 201 ||
          response['status_code'] == 200) {

        currentLocation.value =
            LectureLocationModel.fromJson(response['data']);

        Get.snackbar(
          "نجاح",
          "تم تحديد الموقع",
        );
      }

    } catch (e) {

      print("Create Error: $e");

      Get.snackbar(
        "خطأ",
        "فشل إنشاء الموقع",
      );
    }
  }

  // 3. تعديل الموقع (Update)
  Future<void> updateLocation(int locationId, int lectureId, String labName) async {
    try {
      final response = await _apiService.put('/admin/lecture-locations/$locationId', {
        'lecture_id': lectureId,
        'lab_name': labName,
      });
      if (response['status_code'] == 200) {
        fetchLocationDetails(lectureId);
      }
    } catch (e) {
      print("Update Error: $e");
    }
  }

  // 4. حذف الموقع (Destroy)
  Future<void> deleteLocation(int locationId, int lectureId) async {
    try {
      final response = await _apiService.delete('/admin/lecture-locations/$locationId');
      if (response['status_code'] == 200) {
        currentLocation.value = null;
        Get.snackbar("نجاح", "تم حذف الموقع");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الحذف");
    }
  }

  // 5. إسناد فئة (Assign Group)
  Future<void> assignGroup(
      int locationId,
      int groupId,
      int lectureId,
      ) async {
    try {

      final response = await _apiService.post(
        '/admin/lecture-locations/$locationId/groups',
        {
          'group_ids': [groupId],
        },
      );

      if (response['status_code'] == 200 ||
          response['status_code'] == 201) {

        fetchLocationDetails(locationId);

        Get.snackbar(
          "نجاح",
          "تم إسناد الفئة",
        );
      }

    } catch (e) {

      print("Assign Error: $e");

      Get.snackbar(
        "خطأ",
        "فشل إسناد الفئة",
      );
    }
  }
  // 6. إزالة فئة (Remove Group)
  // المسار: /admin/lecture-locations/{{lecture_location_id}}/groups/{{group_id}}
  Future<void> removeGroupFromLocation(int locationId, int groupId, int lectureId) async {
    try {
      await _apiService.delete('/admin/lecture-locations/$locationId/groups/$groupId');
      fetchLocationDetails(lectureId);
    } catch (e) {
      Get.snackbar("خطأ", "فشل إزالة الفئة");
    }
  }
}