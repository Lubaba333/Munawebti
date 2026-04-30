import 'package:get/get.dart';

enum ViolationSeverity { low, medium, high, critical }

class Violation {
  final String user;
  final String title;
  final String desc;
  final ViolationSeverity severity;
  final int points;

  Violation({
    required this.user,
    required this.title,
    required this.desc,
    required this.severity,
    required this.points,
  });
}

class ViolationController extends GetxController {

  var violations = <Violation>[].obs;

  var filter = "All".obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    violations.value = [
      Violation(
        user: "Sara",
        title: "Late Attendance",
        desc: "Arrived 20 min late",
        severity: ViolationSeverity.low,
        points: 1,
      ),
      Violation(
        user: "Mona",
        title: "Missed Report",
        desc: "Did not submit report",
        severity: ViolationSeverity.medium,
        points: 3,
      ),
      Violation(
        user: "Lina",
        title: "Serious Violation",
        desc: "Repeated issue",
        severity: ViolationSeverity.critical,
        points: 10,
      ),
    ];
  }

  List<Violation> get filtered {
    if (filter.value == "All") return violations;

    return violations.where((v) {
      return v.severity.name == filter.value;
    }).toList();
  }

  int get total => violations.length;

  int get critical =>
      violations.where((e) => e.severity == ViolationSeverity.critical).length;
}