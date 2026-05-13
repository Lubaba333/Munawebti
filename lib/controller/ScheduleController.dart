// import 'package:get/get.dart';

// class ScheduleController extends GetxController {
//   var isLoading = false.obs;

//   var shifts = <Map<String, dynamic>>[].obs;

//   /// 🔥 Calendar
//   var selectedIndex = 0.obs;
//   List<Map<String, String>> days = [];

//   @override
//   void onInit() {
//     super.onInit();
//     generateDays();
//     loadMockData();
//   }

//   void generateDays() {
//     DateTime now = DateTime.now();

//     days = List.generate(7, (index) {
//       DateTime date = now.add(Duration(days: index));

//       return {
//         "day": _getDayName(date.weekday),
//         "date": date.day.toString(),
//       };
//     });
//   }

//   String _getDayName(int weekday) {
//     switch (weekday) {
//       case 1:
//         return "Mon";
//       case 2:
//         return "Tue";
//       case 3:
//         return "Wed";
//       case 4:
//         return "Thu";
//       case 5:
//         return "Fri";
//       case 6:
//         return "Sat";
//       case 7:
//         return "Sun";
//       default:
//         return "";
//     }
//   }

//   void selectDay(int index) {
//     selectedIndex.value = index;

//     /// 🔥 لاحقاً:
//     /// فلترة الشفتات حسب اليوم
//   }

//   void loadMockData() {
//     isLoading.value = true;

//     Future.delayed(Duration(seconds: 1), () {
//       shifts.value = [
//         {
//           "title": "Hospital Training",
//           "location": "Al-Assad Hospital",
//           "time": "08:00 - 02:00",
//           "status": "today"
//         },
//         {
//           "title": "Dorm Supervision",
//           "location": "Dorm A",
//           "time": "03:00 - 08:00",
//           "status": "upcoming"
//         },
//         {
//           "title": "Lecture Monitoring",
//           "location": "Classroom 3",
//           "time": "09:00 - 11:00",
//           "status": "done"
//         },
//       ];

//       isLoading.value = false;
//     });
//   }
// }



import 'package:get/get.dart';

class ScheduleController extends GetxController {
  var isLoading = false.obs;

  var shifts = <Map<String, dynamic>>[].obs;

  /// 🔍 Search
  var searchQuery = "".obs;

  /// Filters
  var selectedLocation = "All".obs;
  var selectedShift = "All".obs;
  var showOnlyMine = true.obs;

  String myName = "Sara";

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      shifts.value = [
        {
          "title": "Hospital Training",
          "supervisor": "Sara",
          "location": "Hospital",
          "shiftType": "Morning",
          "time": "08:00 - 02:00",
          "status": "assigned"
        },
        {
          "title": "Dorm Supervision",
          "supervisor": "Lina",
          "location": "Dorm A",
          "shiftType": "Evening",
          "time": "03:00 - 08:00",
          "status": "pending"
        },
      ];

      isLoading.value = false;
    });
  }

  void toggleView(bool value) {
    showOnlyMine.value = value;
  }

  void search(String value) {
    searchQuery.value = value;
  }

  /// 🔥 Filter Logic
  List<Map<String, dynamic>> get filteredShifts {
    return shifts.where((s) {

      if (showOnlyMine.value && s['supervisor'] != myName) {
        return false;
      }

      if (selectedLocation.value != "All" &&
          s['location'] != selectedLocation.value) {
        return false;
      }

      if (selectedShift.value != "All" &&
          s['shiftType'] != selectedShift.value) {
        return false;
      }

      if (searchQuery.value.isNotEmpty &&
          !s['supervisor']
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }
}