import 'package:get/get.dart';
import 'package:supervisors/models/housing_complaint_model.dart';
import '../services/api_service.dart';
import 'AuthController.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final ApiService apiService = ApiService();

  var isLoading = false.obs;

  String get userName =>
      authController.supervisor.value?.fullName ?? "";

  var currentShift = {
    "title": "Hospital",
    "type": "Morning",
    "time": "08:00 - 02:00",
    "status": "active"
  }.obs;

  var todaySchedule = <Map<String, String>>[].obs;

  var notifications = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTodayShifts();
  }

  Future<void> getTodayShifts() async {

    try {

      isLoading.value = true;

      todaySchedule.clear();

      final response = await apiService.get(

        "/supervisor/my-shifts",

        queryParameters: {

          "per_page": 15,
          "page": 1,
          "today": 1,

        },

      );

      final data = response["data"] ?? {};
//------------------ lectures ------------------//

      if (data["lecture"] != null) {

        for (var lecture in data["lecture"]) {

          final assignment =
          lecture["lecture_supervisor_assignment"];

          if (assignment == null) continue;

          final lec = assignment["lecture"];
          todaySchedule.add({

            "time":
            "${lecture["from_hour"].toString().substring(0,5)} - ${lecture["to_hour"].toString().substring(0,5)}",

            "place":
            lec["subject"]["name"],

            "teacher":
            lec["teacher_name"] ?? "",

            "lab":
            assignment["lecture_location_assignment"]?["lab_name"] ?? "",

            "specialization":
            lec["specialization"] ?? "",

            "year":
            lec["year"].toString(),

            "type":
            "lecture",

          });

        }

      }

      //------------------ housing ------------------//

      if (data["housing"] != null) {

        for (var housing in data["housing"]) {

          final assignment =
          housing["housing_supervisor_assignment"];

          if (assignment == null) continue;
          todaySchedule.add({

            "time":
            "${housing["from_hour"].toString().substring(0,5)} - ${housing["to_hour"].toString().substring(0,5)}",

            "place":
            assignment["dormitory_unit"]["name"],

            "type":
            "housing",

          });

        }

      }

      //---------------- Current Shift ----------------//

      if (todaySchedule.isNotEmpty) {

        currentShift.value = {

          "title": todaySchedule.first["place"]!,

          "time": todaySchedule.first["time"]!,

          "type": todaySchedule.first["type"]!,

          "status": "active",

        };

      } else {

        currentShift.value = {

          "title": "لا توجد مناوبات اليوم",

          "time": "--",

          "type": "",

          "status": "",

        };

      }
    }catch (e) {

      print(e);

    } finally {

      isLoading.value = false;

    }

  }


  /// 🔵 REAL API CALL (Correct place)
  Future<HousingComplaint> getComplaintById(int id) async {
    try {
      final response = await apiService.get(
        '/supervisor/housing-complaints/$id',
      );

      return HousingComplaint.fromJson(response['data']);
    } catch (e) {
      throw Exception("Failed to load complaint: $e");
    }
  }
}