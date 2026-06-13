import 'package:get/get.dart';
import '../models/dormitory_attendance_model.dart';
import '../services/service.dart';

class DormitoryAttendanceController extends GetxController {
  final ApiService _api = ApiService();

  var isLoading = false.obs;
  var attendanceList = <DormitoryAttendance>[].obs;

  var selectedAttendance = Rxn<DormitoryAttendance>();

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  /// 📡 GET LIST
  Future<void> fetchAttendance() async {
    isLoading.value = true;

    try {
      final response = await _api.get(
        '/student/dormitory-attendance',
        queryParameters: {
          'per_page': 15,
          'page': 1,
        },
        authRequired: true,
      );

      print("🏠 Dormitory Attendance Response: $response");

      final data = response['data'];

      List list = [];

      if (data is List) {
        list = data;
      } else if (data is Map) {
        if (data['data'] is List) {
          list = data['data'];
        } else if (data['attendance'] is List) {
          list = data['attendance'];
        } else if (data['records'] is List) {
          list = data['records'];
        } else if (data['items'] is List) {
          list = data['items'];
        } else if (data['dormitory_attendance'] is List) {
          list = data['dormitory_attendance'];
        }
      }

      attendanceList.value = list
          .map((e) => DormitoryAttendance.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();

      print("✅ Dormitory Attendance Loaded: ${attendanceList.length}");
    } catch (e) {
      print("❌ Attendance Error: $e");
      attendanceList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 📡 GET DETAILS
  Future<void> fetchAttendanceDetails(int id) async {
    isLoading.value = true;

    try {
      final response = await _api.get(
        '/student/dormitory-attendance/$id',
        authRequired: true,
      );

      print("🏠 Dormitory Attendance Details Response: $response");

      final data = response['data'];

      if (data is Map) {
        selectedAttendance.value = DormitoryAttendance.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
    } catch (e) {
      print("❌ Details Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}