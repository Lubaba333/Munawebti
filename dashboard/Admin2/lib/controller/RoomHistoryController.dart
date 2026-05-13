import 'package:get/get.dart';
import '../model/RoomStudentHistoryModel.dart';
import '../services/api_service.dart';

class StudentHistoryController extends GetxController {
  final ApiService api = Get.find();

  var isLoading = false.obs;
  var history = <StudentRoomHistoryModel>[].obs;

  Future<void> fetchStudentHistory(int studentId) async {
    try {
      isLoading.value = true;

      final response = await api.get(
        '/admin/students/$studentId/room-history',
      );

      final responseData = response['data'];

      final List data = responseData is List
          ? responseData
          : responseData?['data'] ?? [];

      history.value =
          data.map((e) => StudentRoomHistoryModel.fromJson(e)).toList();

    } catch (e) {
      print("STUDENT HISTORY ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}