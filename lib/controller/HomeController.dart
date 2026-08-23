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

  final RxBool isLoading = false.obs;

  // ============================================================
  // User Name
  // ============================================================

  String get userName =>
      authController.supervisor.value?.fullName ?? "";

  // ============================================================
  // Current Lecture
  // ============================================================

  final RxMap<String, String> currentShift =
      <String, String>{
        "title": "لا توجد محاضرة حالياً",
        "type": "lecture",
        "time": "--",
        "status": "",
        "teacher": "",
        "lab": "",
        "specialization": "",
        "year": "",
      }.obs;

  // ============================================================
  // Today's Schedule
  // ============================================================

  final RxList<Map<String, String>> todaySchedule =
      <Map<String, String>>[].obs;

  // ============================================================
  // Notifications
  // ============================================================

  final RxList<String> notifications =
      <String>[].obs;

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

    // جلب محاضرات ومناوبات اليوم
    getTodayShifts();

    // تحديث المحاضرة الحالية كل 30 ثانية
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

      // تنظيف البيانات القديمة
      todaySchedule.clear();

      // ========================================================
      // API REQUEST
      // ========================================================

      final response = await apiService.get(
        "/supervisor/my-shifts",
        queryParameters: {
          "per_page": 15,
          "page": 1,
          "today": 1,
        },
      );

      print("====================================");
      print("TODAY SHIFTS RESPONSE:");
      print(response);
      print("====================================");

      final data = response["data"];

      if (data == null) {
        print("No data returned from API");
        updateCurrentLecture();
        return;
      }

      // ========================================================
      // LECTURES
      // ========================================================

      final lectures = data["lecture"];

      if (lectures is List) {
        for (final lecture in lectures) {
          if (lecture is! Map) {
            continue;
          }

          // ----------------------------------------------------
          // Assignment
          // ----------------------------------------------------

          final assignment =
          lecture["lecture_supervisor_assignment"];

          if (assignment is! Map) {
            print("Lecture assignment is null");
            continue;
          }

          // ----------------------------------------------------
          // Lecture
          // ----------------------------------------------------

          final lec = assignment["lecture"];

          if (lec is! Map) {
            print("Lecture object is null");
            continue;
          }

          // ----------------------------------------------------
          // Time
          // ----------------------------------------------------

          final fromHour =
              lecture["from_hour"]?.toString() ??
                  assignment["from_hour"]?.toString() ??
                  lec["from_hour"]?.toString() ??
                  "";

          final toHour =
              lecture["to_hour"]?.toString() ??
                  assignment["to_hour"]?.toString() ??
                  lec["to_hour"]?.toString() ??
                  "";

          // ----------------------------------------------------
          // Subject
          // ----------------------------------------------------

          final subject = lec["subject"];

          String subjectName = "";

          if (subject is Map) {
            subjectName =
                subject["name"]?.toString() ?? "";
          }

          // ----------------------------------------------------
          // Location
          // ----------------------------------------------------

          final locationAssignment =
          assignment["lecture_location_assignment"];

          String labName = "";

          if (locationAssignment is Map) {
            labName =
                locationAssignment["lab_name"]
                    ?.toString() ??
                    "";
          }

          // ----------------------------------------------------
          // Add Lecture
          // ----------------------------------------------------

          final from = _formatTime(fromHour);
          final to = _formatTime(toHour);

          final lectureItem = <String, String>{
            "time": "$from - $to",

            // نحتفظ بها للمقارنة
            "from": from,
            "to": to,

            // اسم المادة
            "place": subjectName,

            // المدرس
            "teacher":
            lec["teacher_name"]?.toString() ?? "",

            // المدرج / المختبر
            "lab": labName,

            // الاختصاص
            "specialization":
            lec["specialization"]
                ?.toString() ??
                "",

            // السنة
            "year":
            lec["year"]?.toString() ?? "",

            // النوع
            "type": "lecture",
          };

          todaySchedule.add(lectureItem);

          print(
            "Added lecture: "
                "$subjectName | $from -> $to",
          );
        }
      }

      // ========================================================
      // HOUSING
      // ========================================================

      final housingList = data["housing"];

      if (housingList is List) {
        for (final housing in housingList) {
          if (housing is! Map) {
            continue;
          }

          final assignment =
          housing["housing_supervisor_assignment"];

          if (assignment is! Map) {
            continue;
          }

          // ----------------------------------------------------
          // Housing Time
          // ----------------------------------------------------

          final fromHour =
              housing["from_hour"]?.toString() ??
                  assignment["from_hour"]?.toString() ??
                  "";

          final toHour =
              housing["to_hour"]?.toString() ??
                  assignment["to_hour"]?.toString() ??
                  "";

          // ----------------------------------------------------
          // Dormitory
          // ----------------------------------------------------

          final dormitory =
          assignment["dormitory_unit"];

          String dormitoryName = "";

          if (dormitory is Map) {
            dormitoryName =
                dormitory["name"]?.toString() ?? "";
          }

          // ----------------------------------------------------
          // Add Housing
          // ----------------------------------------------------

          final from = _formatTime(fromHour);
          final to = _formatTime(toHour);

          todaySchedule.add({
            "time": "$from - $to",
            "from": from,
            "to": to,
            "place": dormitoryName,
            "type": "housing",
          });

          print(
            "Added housing: "
                "$dormitoryName | $from -> $to",
          );
        }
      }

      // ========================================================
      // SORT SCHEDULE
      // ========================================================

      todaySchedule.sort(
            (a, b) {
          final aTime =
          _timeToMinutes(a["from"] ?? "");

          final bTime =
          _timeToMinutes(b["from"] ?? "");

          return aTime.compareTo(bTime);
        },
      );

      print("====================================");
      print("TODAY SCHEDULE:");
      print(todaySchedule);
      print("====================================");

      // ========================================================
      // UPDATE CURRENT LECTURE
      // ========================================================

      updateCurrentLecture();
    } catch (e, stackTrace) {
      print("====================================");
      print("getTodayShifts ERROR:");
      print(e);
      print(stackTrace);
      print("====================================");

      _setNoCurrentLecture();
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UPDATE CURRENT LECTURE
  // ============================================================

  void updateCurrentLecture() {
    final now = DateTime.now();

    final currentMinutes =
        now.hour * 60 + now.minute;

    print("====================================");
    print("CHECK CURRENT LECTURE");
    print("Current Date: $now");
    print("Current Minutes: $currentMinutes");
    print("====================================");

    Map<String, String>? currentLecture;

    // ==========================================================
    // SEARCH CURRENT LECTURE
    // ==========================================================

    for (final item in todaySchedule) {
      // نريد المحاضرات فقط
      if (item["type"] != "lecture") {
        continue;
      }

      final from =
      _timeToMinutes(item["from"] ?? "");

      final to =
      _timeToMinutes(item["to"] ?? "");

      print(
        "Lecture: ${item["place"]} | "
            "${item["from"]} -> ${item["to"]} | "
            "$from -> $to",
      );

      // ========================================================
      // CURRENT TIME IS INSIDE LECTURE TIME
      // ========================================================

      if (currentMinutes >= from &&
          currentMinutes < to) {
        currentLecture = item;

        print(
          "CURRENT LECTURE FOUND: "
              "${item["place"]}",
        );

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

        "type": "lecture",

        "status": "active",

        "teacher":
        currentLecture["teacher"] ?? "",

        "lab":
        currentLecture["lab"] ?? "",

        "specialization":
        currentLecture["specialization"] ?? "",

        "year":
        currentLecture["year"] ?? "",
      };

      print(
        "HOME CURRENT SHIFT: "
            "${currentShift["title"]}",
      );

      return;
    }

    // ==========================================================
    // NO CURRENT LECTURE
    // ==========================================================

    print("NO CURRENT LECTURE");

    _setNoCurrentLecture();
  }

  // ============================================================
  // SET NO CURRENT LECTURE
  // ============================================================

  void _setNoCurrentLecture() {
    currentShift.value = {
      "title": "لا توجد محاضرة حالياً",
      "time": "--",
      "type": "lecture",
      "status": "",
      "teacher": "",
      "lab": "",
      "specialization": "",
      "year": "",
    };
  }

  // ============================================================
  // CONVERT TIME TO MINUTES
  // ============================================================

  int _timeToMinutes(String time) {
    try {
      if (time.isEmpty) {
        return 0;
      }

      final parts = time.split(":");

      if (parts.length < 2) {
        return 0;
      }

      final hour =
          int.tryParse(parts[0].trim()) ?? 0;

      final minute =
          int.tryParse(parts[1].trim()) ?? 0;

      return hour * 60 + minute;
    } catch (e) {
      print(
        "_timeToMinutes error: $e | time=$time",
      );

      return 0;
    }
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(String time) {
    if (time.isEmpty) {
      return "";
    }

    // 08:30:00 -> 08:30
    if (time.length >= 5) {
      return time.substring(0, 5);
    }

    return time;
  }

  // ============================================================
  // GET COMPLAINT BY ID
  // ============================================================

  Future<HousingComplaint> getComplaintById(
      int id,
      ) async {
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