import 'package:get/get.dart';

class User {
  String name;
  String role;

  bool isActive;
  bool isDeleted; // 👈 مهم جدًا

  int warnings;
  int bonuses;

  int graduationYear;
  String graduationPlace;
  String graduationDate;

  List<String> activityLog;

  User({
    required this.name,
    required this.role,
    this.isActive = true,
    this.isDeleted = false,

    this.warnings = 0,
    this.bonuses = 0,

    this.graduationYear = 0,
    this.graduationPlace = "",
    this.graduationDate = "",

    this.activityLog = const [],
  });
}


class UserManagementController extends GetxController {
  /// ================= FILTER =================
  var filter = "All".obs;

  void setFilter(String value) {
    filter.value = value;
  }

  /// ================= USERS =================
  var users = <User>[
    User(
      name: "Fatima Ali",
      role: "Nurse",
      warnings: 1,
      bonuses: 2,
      graduationYear: 2022,
      graduationPlace: "Damascus University",
      graduationDate: "2022-06-10",
      activityLog: ["Created account"],
    ),
    User(
      name: "Sara Ahmed",
      role: "Student",
      warnings: 0,
      bonuses: 1,
      graduationYear: 2023,
      graduationPlace: "Ain Shams",
      graduationDate: "2023-07-15",
      activityLog: ["Joined system"],
    ),
    User(
      name: "Sara Ahmed",
      role: "Student",
      warnings: 0,
      bonuses: 1,
      graduationYear: 2023,
      graduationPlace: "Ain Shams",
      graduationDate: "2023-07-15",
      activityLog: ["Joined system"],
    ),User(
      name: "Sara Ahmed",
      role: "Student",
      warnings: 0,
      bonuses: 1,
      graduationYear: 2023,
      graduationPlace: "Ain Shams",
      graduationDate: "2023-07-15",
      activityLog: ["Joined system"],
    ),
    User(
      name: "Lama Noor",
      role: "Nurse",
      warnings: 2,
      bonuses: 3,
      graduationYear: 2021,
      graduationPlace: "Cairo University",
      graduationDate: "2021-09-20",
      activityLog: ["Warning issued"],
    ),
    User(
      name: "Sara Ahmed",
      role: "Student",
      warnings: 0,
      bonuses: 1,
      graduationYear: 2023,
      graduationPlace: "Ain Shams",
      graduationDate: "2023-07-15",
      activityLog: ["Joined system"],
    ),
    User(
      name: "Lama Noor",
      role: "Nurse",
      warnings: 2,
      bonuses: 3,
      graduationYear: 2021,
      graduationPlace: "Cairo University",
      graduationDate: "2021-09-20",
      activityLog: ["Warning issued"],
    ), User(
      name: "Lama Noor",
      role: "Nurse",
      warnings: 2,
      bonuses: 3,
      graduationYear: 2021,
      graduationPlace: "Cairo University",
      graduationDate: "2021-09-20",
      activityLog: ["Warning issued"],
    ),
    User(
      name: "Sara Ahmed",
      role: "Student",
      warnings: 0,
      bonuses: 1,
      graduationYear: 2023,
      graduationPlace: "Ain Shams",
      graduationDate: "2023-07-15",
      activityLog: ["Joined system"],
    ),

  ].obs;

  /// ================= FILTER LOGIC =================
  List<User> get filteredUsers {
    if (filter.value == "All") {
      return users.where((u) => !u.isDeleted).toList();
    }

    if (filter.value == "Nurses") {
      return users
          .where((u) => u.role == "Nurse" && !u.isDeleted)
          .toList();
    }

    if (filter.value == "Students") {
      return users
          .where((u) => u.role == "Student" && !u.isDeleted)
          .toList();
    }

    if (filter.value == "Deleted") {
      return users.where((u) => u.isDeleted).toList();
    }

    return users.where((u) => !u.isDeleted).toList();
  }

  /// ================= ADD =================
  void addUser(User user) {
    user.activityLog = ["User created"];
    users.add(user);
  }

  /// ================= UPDATE =================
  void updateUser(int index, User newUser) {
    newUser.activityLog = users[index].activityLog;
    newUser.activityLog.add("Profile updated");

    users[index] = newUser;
    users.refresh();
  }

  /// ================= SOFT DELETE =================
  void softDelete(User user) {
    user.isDeleted = true;
    user.activityLog.add("Moved to deleted");
    users.refresh();
  }

  /// ================= RESTORE =================
  void restoreUser(User user) {
    user.isDeleted = false;
    user.activityLog.add("Restored");

    users.refresh(); // 👈 مهم لإعادة الفرز والفلترة
  }

  /// ================= ACTIVITY =================
  void addActivity(User user, String log) {
    user.activityLog.add(log);
    users.refresh();
  }

  /// ================= TOGGLE STATUS =================
  void toggleUserStatus(User user) {
    user.isActive = !user.isActive;

    user.activityLog.add(
      user.isActive ? "Activated" : "Deactivated",
    );

    users.refresh();
  }
}