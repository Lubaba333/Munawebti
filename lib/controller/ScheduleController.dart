// import 'package:get/get.dart';

// class ScheduleController extends GetxController {
//   var isLoading = false.obs;

//   var shifts = <Map<String, dynamic>>[].obs;

//   /// 🔍 Search
//   var searchQuery = "".obs;

//   /// Filters
//   var selectedLocation = "All".obs;
//   var selectedShift = "All".obs;
//   var showOnlyMine = true.obs;

//   String myName = "Sara";

//   @override
//   void onInit() {
//     super.onInit();
//     loadMockData();
//   }

//   void loadMockData() {
//     isLoading.value = true;

//     Future.delayed(Duration(seconds: 1), () {
//       shifts.value = [
//         {
//           "title": "Hospital Training",
//           "supervisor": "Sara",
//           "location": "Hospital",
//           "shiftType": "Morning",
//           "time": "08:00 - 02:00",
//           "status": "assigned"
//         },
//         {
//           "title": "Dorm Supervision",
//           "supervisor": "Lina",
//           "location": "Dorm A",
//           "shiftType": "Evening",
//           "time": "03:00 - 08:00",
//           "status": "pending"
//         },
//       ];

//       isLoading.value = false;
//     });
//   }

//   void toggleView(bool value) {
//     showOnlyMine.value = value;
//   }

//   void search(String value) {
//     searchQuery.value = value;
//   }

//   /// 🔥 Filter Logic
//   List<Map<String, dynamic>> get filteredShifts {
//     return shifts.where((s) {

//       if (showOnlyMine.value && s['supervisor'] != myName) {
//         return false;
//       }

//       if (selectedLocation.value != "All" &&
//           s['location'] != selectedLocation.value) {
//         return false;
//       }

//       if (selectedShift.value != "All" &&
//           s['shiftType'] != selectedShift.value) {
//         return false;
//       }

//       if (searchQuery.value.isNotEmpty &&
//           !s['supervisor']
//               .toLowerCase()
//               .contains(searchQuery.value.toLowerCase())) {
//         return false;
//       }

//       return true;
//     }).toList();
//   }
// } 



import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ScheduleController extends GetxController {

  /// الأيام
  final days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
  ];

  /// الفترات الزمنية
  final timeSlots = [
    "8:30 - 10:30",
    "10:30 - 12:30",
    "12:30 - 2:30",
  ];

  /// بيانات الجدول
  /// جاهزة مستقبلاً للـ API
  final RxList<Map<String, dynamic>> schedules = <Map<String, dynamic>>[
    {
      "day": "Sunday",
      "slots": [
        {
          "title": "Hospital A",
          "type": "Training",
        },
        {
          "title": "Clinical",
          "type": "Supervision",
        },
        {
          "title": "Meeting",
          "type": "Meeting",
        },
      ]
    },
    {
      "day": "Monday",
      "slots": [
        {
          "title": "Hospital B",
          "type": "Training",
        },
        {
          "title": "Evaluation",
          "type": "Evaluation",
        },
        {
          "title": "-",
          "type": "Empty",
        },
      ]
    },
    {
      "day": "Tuesday",
      "slots": [
        {
          "title": "Clinical",
          "type": "Supervision",
        },
        {
          "title": "-",
          "type": "Empty",
        },
        {
          "title": "Meeting",
          "type": "Meeting",
        },
      ]
    },
    {
      "day": "Wednesday",
      "slots": [
        {
          "title": "Hospital C",
          "type": "Training",
        },
        {
          "title": "Clinical",
          "type": "Supervision",
        },
        {
          "title": "Evaluation",
          "type": "Evaluation",
        },
      ]
    },
    {
      "day": "Thursday",
      "slots": [
        {
          "title": "-",
          "type": "Empty",
        },
        {
          "title": "Training",
          "type": "Training",
        },
        {
          "title": "Meeting",
          "type": "Meeting",
        },
      ]
    },
  ].obs;

  /// ألوان الحالات
  Color getCardColor(String type) {
    switch (type) {
      case "Training":
        return const Color(0xFFDFF5E8);

      case "Supervision":
        return const Color(0xFFE7E4FF);

      case "Meeting":
        return const Color(0xFFFFE8D9);

      case "Evaluation":
        return const Color(0xFFFFE0EB);

      default:
        return Colors.grey.shade100;
    }
  }

  Color getTextColor(String type) {
    switch (type) {
      case "Training":
        return Colors.green;

      case "Supervision":
        return Colors.deepPurple;

      case "Meeting":
        return Colors.orange;

      case "Evaluation":
        return Colors.pink;

      default:
        return Colors.grey;
    }
  }
}