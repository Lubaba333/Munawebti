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
    fetchAttendance();
    super.onInit();
  }

  /// 📡 GET LIST
  Future<void> fetchAttendance() async {
    isLoading.value = true;

    try {
      final response = await _api.get('/student/dormitory-attendance');

      final data = response['data'];

      List list = [];

      if (data is Map && data['data'] != null) {
        list = data['data'];
      } else if (data is List) {
        list = data;
      }

      attendanceList.value = list
          .map((e) => DormitoryAttendance.fromJson(e))
          .toList();

    } catch (e) {
      print("❌ Attendance Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 📡 GET DETAILS
  Future<void> fetchAttendanceDetails(int id) async {
    isLoading.value = true;

    try {
      final response =
          await _api.get('/student/dormitory-attendance/$id');

      final data = response['data'];

      if (data != null) {
        selectedAttendance.value =
            DormitoryAttendance.fromJson(data);
      }

    } catch (e) {
      print("❌ Details Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}