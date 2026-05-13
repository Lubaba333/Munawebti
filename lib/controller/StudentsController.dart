import 'package:get/get.dart';

class StudentsController extends GetxController {
  var students = <Map<String, dynamic>>[].obs;
  var filteredStudents = <Map<String, dynamic>>[].obs;

  var search = "".obs;

  /// 🔥 Attendance Session
  var isSessionActive = false.obs;
  var isSubmitted = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    students.value = [
      {"name": "Sara Ali", "present": false},
      {"name": "Lina Ahmad", "present": false},
      {"name": "Maya Hassan", "present": false},
      {"name": "Noor Khaled", "present": false},
    ];

    filteredStudents.value = students;
  }

  /// ▶️ Start Session
  void startSession() {
    isSessionActive.value = true;
    isSubmitted.value = false;
  }

  /// 🔁 Toggle Attendance
  void toggleAttendance(int index) {
    if (!isSessionActive.value || isSubmitted.value) return;

    filteredStudents[index]['present'] =
        !filteredStudents[index]['present'];
    filteredStudents.refresh();
  }

  /// ⚡ Mark All
  void markAll(bool value) {
    if (!isSessionActive.value) return;

    for (var s in filteredStudents) {
      s['present'] = value;
    }
    filteredStudents.refresh();
  }

  /// ✅ Submit
  void submitAttendance() {
    isSessionActive.value = false;
    isSubmitted.value = true;

    Get.snackbar("Success", "Attendance Submitted ✅");
  }

  /// 🔍 Search
  void searchStudent(String value) {
    search.value = value;

    filteredStudents.value = students
        .where((s) =>
            s['name'].toLowerCase().contains(value.toLowerCase()))
        .toList();
  } 

  void markByQR(String name) {
  if (!isSessionActive.value || isSubmitted.value) return;

  final index =
      students.indexWhere((s) => s['name'] == name);

  if (index != -1) {
    students[index]['present'] = true;
    students.refresh();

    Get.snackbar("Success", "$name marked present ✅");
  } else {
    Get.snackbar("Error", "Student not found ❌");
  }
}
}