import 'package:get/get.dart';
import '../services/api_service.dart';
import '../model/RoomStudentModel.dart';

class RoomStudentsController extends GetxController {
  final ApiService api = Get.find();

  var students = <RoomStudentModel>[].obs;
  var isLoading = false.obs;

  /// 🔵 GET ROOM STUDENTS
  Future<void> fetchStudents(int roomId) async {
    try {

      isLoading.value = true;

      final response = await api.get(
        '/admin/rooms/$roomId/students',
      );

      print("STUDENTS RESPONSE: $response");

      final List data = response['data']['data'] ?? [];

      students.value =
          data.map((e) => RoomStudentModel.fromJson(e)).toList();

    } catch (e) {

      print("FETCH STUDENTS ERROR: $e");

    } finally {

      isLoading.value = false;

    }
  }

  /// 🟢 ASSIGN STUDENT
  Future<void> assignStudent({
    required int roomId,
    required int studentId,
  }) async {
    try {
      await api.post(
        '/admin/rooms/$roomId/students',
        {
          "student_ids": [studentId],
          "move_in_date": DateTime.now()
              .toIso8601String()
              .split("T")[0],
        },
      );

      fetchStudents(roomId);

      Get.snackbar("نجاح", "تم إضافة الطالب");

    } catch (e) {
      print("ASSIGN ERROR: $e");
      Get.snackbar("خطأ", "فشل إضافة الطالب");
    }
  }
  /// 🔴 REMOVE STUDENT
  Future<void> removeStudent({
    required int roomId,
    required int studentId,
  }) async {
    try {
      await api.delete(
        '/admin/rooms/$roomId/students/$studentId',
      );

      fetchStudents(roomId);

    } catch (e) {
      print("REMOVE ERROR: $e");

      Get.snackbar(
        "خطأ",
        "فشل حذف الطالب",
      );
    }
  }
}