// import 'package:get/get.dart';
// import 'package:supervisors/models/housing_complaint_model.dart';
// import '../services/api_service.dart';
// import 'AuthController.dart';
//
// class HomeController extends GetxController {
//   final AuthController authController = Get.find<AuthController>();
//
//   final ApiService apiService = ApiService();
//
//   var isLoading = false.obs;
//
//   String get userName =>
//       authController.supervisor.value?.fullName ?? "";
//
//   var currentShift = {
//     "title": "Hospital",
//     "type": "Morning",
//     "time": "08:00 - 02:00",
//     "status": "active"
//   }.obs;
//
//   var todaySchedule = <Map<String, String>>[].obs;
//
//   var notifications = <String>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getTodayShifts();
//   }
//
//   Future<void> getTodayShifts() async {
//
//     try {
//
//       isLoading.value = true;
//
//       todaySchedule.clear();
//
//       final response = await apiService.get(
//
//         "/supervisor/my-shifts",
//
//         queryParameters: {
//
//           "per_page": 15,
//           "page": 1,
//           "today": 1,
//
//         },
//
//       );
//
//       final data = response["data"] ?? {};
// //------------------ lectures ------------------//
//
//       if (data["lecture"] != null) {
//
//         for (var lecture in data["lecture"]) {
//
//           final assignment =
//           lecture["lecture_supervisor_assignment"];
//
//           if (assignment == null) continue;
//
//           final lec = assignment["lecture"];
//           todaySchedule.add({
//
//             "time":
//             "${lecture["from_hour"].toString().substring(0,5)} - ${lecture["to_hour"].toString().substring(0,5)}",
//
//             "place":
//             lec["subject"]["name"],
//
//             "teacher":
//             lec["teacher_name"] ?? "",
//
//             "lab":
//             assignment["lecture_location_assignment"]?["lab_name"] ?? "",
//
//             "specialization":
//             lec["specialization"] ?? "",
//
//             "year":
//             lec["year"].toString(),
//
//             "type":
//             "lecture",
//
//           });
//
//         }
//
//       }
//
//       //------------------ housing ------------------//
//
//       if (data["housing"] != null) {
//
//         for (var housing in data["housing"]) {
//
//           final assignment =
//           housing["housing_supervisor_assignment"];
//
//           if (assignment == null) continue;
//           todaySchedule.add({
//
//             "time":
//             "${housing["from_hour"].toString().substring(0,5)} - ${housing["to_hour"].toString().substring(0,5)}",
//
//             "place":
//             assignment["dormitory_unit"]["name"],
//
//             "type":
//             "housing",
//
//           });
//
//         }
//
//       }
//
//       //---------------- Current Shift ----------------//
//
//       if (todaySchedule.isNotEmpty) {
//
//         currentShift.value = {
//
//           "title": todaySchedule.first["place"]!,
//
//           "time": todaySchedule.first["time"]!,
//
//           "type": todaySchedule.first["type"]!,
//
//           "status": "active",
//
//         };
//
//       } else {
//
//         currentShift.value = {
//
//           "title": "لا توجد مناوبات اليوم",
//
//           "time": "--",
//
//           "type": "",
//
//           "status": "",
//
//         };
//
//       }
//     }catch (e) {
//
//       print(e);
//
//     } finally {
//
//       isLoading.value = false;
//
//     }
//
//   }
//
//
//   /// 🔵 REAL API CALL (Correct place)
//   Future<HousingComplaint> getComplaintById(int id) async {
//     try {
//       final response = await apiService.get(
//         '/supervisor/housing-complaints/$id',
//       );
//
//       return HousingComplaint.fromJson(response['data']);
//     } catch (e) {
//       throw Exception("Failed to load complaint: $e");
//     }
//   }
// }

import 'dart:async';

import 'package:get/get.dart';
import 'package:supervisors/models/housing_complaint_model.dart';

import '../services/api_service.dart';
import 'AuthController.dart';

class HomeController extends GetxController {
  // ============================================================
  // Controllers & Services
  // ============================================================

  final AuthController authController =
  Get.find<AuthController>();

  final ApiService apiService = ApiService();

  // ============================================================
  // Loading
  // ============================================================

  var isLoading = false.obs;

  // ============================================================
  // User Name
  // ============================================================

  String get userName =>
      authController.supervisor.value?.fullName ?? "";

  // ============================================================
  // Current Lecture
  // ============================================================

  var currentShift = <String, String>{
    "title": "لا توجد محاضرة حالياً",
    "type": "lecture",
    "time": "--",
    "status": "",
  }.obs;

  // ============================================================
  // Today's Schedule
  // ============================================================

  var todaySchedule = <Map<String, String>>[].obs;

  // ============================================================
  // Notifications
  // ============================================================

  var notifications = <String>[].obs;

  // ============================================================
  // Timer
  // ============================================================

  Timer? _shiftTimer;

  // ============================================================
  // ON INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    // جلب مناوبات اليوم
    getTodayShifts();

    // فحص المحاضرة الحالية كل 30 ثانية
    _shiftTimer = Timer.periodic(
      const Duration(seconds: 30),
          (_) {
        updateCurrentLecture();
      },
    );
  }

  // ============================================================
  // ON CLOSE
  // ============================================================

  @override
  void onClose() {
    _shiftTimer?.cancel();

    super.onClose();
  }

  // ============================================================
  // GET TODAY SHIFTS
  // ============================================================

  Future<void> getTodayShifts() async {
    try {
      isLoading.value = true;

      // تنظيف الجدول القديم
      todaySchedule.clear();

      // ========================================================
      // API Request
      // ========================================================

      final response = await apiService.get(
        "/supervisor/my-shifts",
        queryParameters: {
          "per_page": 15,
          "page": 1,
          "today": 1,
        },
      );

      final data = response["data"] ?? {};

      // ========================================================
      // LECTURES
      // ========================================================

      if (data["lecture"] != null) {
        for (var lecture in data["lecture"]) {
          final assignment =
          lecture["lecture_supervisor_assignment"];

          if (assignment == null) {
            continue;
          }

          final lec = assignment["lecture"];

          if (lec == null) {
            continue;
          }

          // ------------------------------------------------------
          // Lecture Time
          // ------------------------------------------------------

          final fromHour =
              lecture["from_hour"]?.toString() ?? "";

          final toHour =
              lecture["to_hour"]?.toString() ?? "";

          // ------------------------------------------------------
          // Subject
          // ------------------------------------------------------

          final subject =
          lec["subject"];

          // ------------------------------------------------------
          // Location
          // ------------------------------------------------------

          final locationAssignment =
          assignment["lecture_location_assignment"];

          // ------------------------------------------------------
          // Add Lecture
          // ------------------------------------------------------

          todaySchedule.add({
            // الوقت للعرض
            "time":
            "${_formatTime(fromHour)} - ${_formatTime(toHour)}",

            // وقت البداية للمقارنة
            "from":
            _formatTime(fromHour),

            // وقت النهاية للمقارنة
            "to":
            _formatTime(toHour),

            // اسم المادة
            "place":
            subject?["name"]?.toString() ?? "",

            // اسم المدرس
            "teacher":
            lec["teacher_name"]?.toString() ?? "",

            // المختبر
            "lab":
            locationAssignment?["lab_name"]?.toString() ?? "",

            // الاختصاص
            "specialization":
            lec["specialization"]?.toString() ?? "",

            // السنة
            "year":
            lec["year"]?.toString() ?? "",

            // النوع
            "type":
            "lecture",
          });
        }
      }

      // ========================================================
      // HOUSING
      // ========================================================

      if (data["housing"] != null) {
        for (var housing in data["housing"]) {
          final assignment =
          housing["housing_supervisor_assignment"];

          if (assignment == null) {
            continue;
          }

          // ------------------------------------------------------
          // Housing Time
          // ------------------------------------------------------

          final fromHour =
              housing["from_hour"]?.toString() ?? "";

          final toHour =
              housing["to_hour"]?.toString() ?? "";

          // ------------------------------------------------------
          // Dormitory
          // ------------------------------------------------------

          final dormitory =
          assignment["dormitory_unit"];

          // ------------------------------------------------------
          // Add Housing
          // ------------------------------------------------------

          todaySchedule.add({
            "time":
            "${_formatTime(fromHour)} - ${_formatTime(toHour)}",

            "from":
            _formatTime(fromHour),

            "to":
            _formatTime(toHour),

            "place":
            dormitory?["name"]?.toString() ?? "",

            "type":
            "housing",
          });
        }
      }

      // ========================================================
      // SORT SCHEDULE
      // ========================================================

      todaySchedule.sort((a, b) {
        final aTime =
        _timeToMinutes(a["from"] ?? "");

        final bTime =
        _timeToMinutes(b["from"] ?? "");

        return aTime.compareTo(bTime);
      });

      // ========================================================
      // UPDATE CURRENT LECTURE
      // ========================================================

      updateCurrentLecture();

    } catch (e) {
      print("getTodayShifts error: $e");

      // في حالة حدوث خطأ
      currentShift.value = {
        "title":
        "لا توجد محاضرة حالياً",

        "time":
        "--",

        "type":
        "lecture",

        "status":
        "",
      };
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UPDATE CURRENT LECTURE
  // ============================================================

  void updateCurrentLecture() {
    // ----------------------------------------------------------
    // الوقت الحالي
    // ----------------------------------------------------------

    final now = DateTime.now();

    final currentMinutes =
        now.hour * 60 + now.minute;

    // المحاضرة الحالية
    Map<String, String>? currentLecture;

    // ==========================================================
    // SEARCH CURRENT LECTURE
    // ==========================================================

    for (final item in todaySchedule) {
      // نريد المحاضرات فقط
      if (item["type"] != "lecture") {
        continue;
      }

      // --------------------------------------------------------
      // وقت البداية
      // --------------------------------------------------------

      final from =
      _timeToMinutes(
        item["from"] ?? "",
      );

      // --------------------------------------------------------
      // وقت النهاية
      // --------------------------------------------------------

      final to =
      _timeToMinutes(
        item["to"] ?? "",
      );

      // --------------------------------------------------------
      // هل المحاضرة جارية الآن؟
      // --------------------------------------------------------

      if (currentMinutes >= from &&
          currentMinutes < to) {
        currentLecture = item;

        break;
      }
    }

    // ==========================================================
    // CURRENT LECTURE FOUND
    // ==========================================================

    if (currentLecture != null) {
      currentShift.value = {
        "title":
        currentLecture["place"] ?? "",

        "time":
        currentLecture["time"] ?? "--",

        "type":
        "lecture",

        "status":
        "active",

        "teacher":
        currentLecture["teacher"] ?? "",

        "lab":
        currentLecture["lab"] ?? "",

        "specialization":
        currentLecture["specialization"] ?? "",

        "year":
        currentLecture["year"] ?? "",
      };

      return;
    }

    // ==========================================================
    // NO CURRENT LECTURE
    // ==========================================================

    currentShift.value = {
      "title":
      "لا توجد محاضرة حالياً",

      "time":
      "--",

      "type":
      "lecture",

      "status":
      "",
    };
  }

  // ============================================================
  // CONVERT TIME TO MINUTES
  // ============================================================

  int _timeToMinutes(String time) {
    try {
      final parts =
      time.split(":");

      if (parts.length < 2) {
        return 0;
      }

      final hour =
          int.tryParse(parts[0]) ?? 0;

      final minute =
          int.tryParse(parts[1]) ?? 0;

      return hour * 60 + minute;

    } catch (e) {
      return 0;
    }
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }

    return time;
  }

  // ============================================================
  // GET COMPLAINT BY ID
  // ============================================================

  Future<HousingComplaint> getComplaintById(
      int id) async {
    try {
      final response =
      await apiService.get(
        '/supervisor/housing-complaints/$id',
      );

      return HousingComplaint.fromJson(
        response['data'],
      );

    } catch (e) {
      throw Exception(
        "Failed to load complaint: $e",
      );
    }
  }
}