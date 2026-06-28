import 'package:get/get.dart';
import '../models/lecture_attendance_model.dart';
import '../services/service.dart';

class LectureAttendanceController extends GetxController {
  final ApiService _api = ApiService();

  final isLoading = false.obs;
  final attendanceList = <LectureAttendanceModel>[].obs;
  final selectedAttendance = Rxn<LectureAttendanceModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      isLoading.value = true;

      final response = await _api.get(
        '/student/lecture-attendance?per_page=15&page=1',
        authRequired: true,
      );

      final data = response['data'];

      List list = [];

      if (data is Map && data['data'] is List) {
        list = data['data'];
      } else if (data is List) {
        list = data;
      }

      attendanceList.value = list
          .whereType<Map>()
          .map((e) => LectureAttendanceModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();

      print("✅ Lecture Attendance Loaded: ${attendanceList.length}");
    } catch (e) {
      print("❌ Lecture Attendance Error: $e");
      attendanceList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAttendanceDetails(int id) async {
    try {
      isLoading.value = true;

      final response = await _api.get(
        '/student/lecture-attendance/$id',
        authRequired: true,
      );

      final data = response['data'];

      if (data is Map) {
        selectedAttendance.value = LectureAttendanceModel.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
    } catch (e) {
      print("❌ Lecture Attendance Details Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}