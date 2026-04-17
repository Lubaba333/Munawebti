import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Supervisor {
  final String name;
  final String image;

  Supervisor({required this.name, required this.image});
}

class Assignment {
  String supervisor;
  List<String> tasks;

  Assignment({
    required this.supervisor,
    required this.tasks,
  });
}

class CreateScheduleController extends GetxController {
  var step = 0.obs;

  var name = "".obs;
  var startDate = DateTime.now().obs;
  var days = 1.obs;

  var supervisors = <Supervisor>[
    Supervisor(name: "Sara", image: "assets/images/nurs.png"),
    Supervisor(name: "Noor", image: "assets/images/nurs.png"),
    Supervisor(name: "Lama", image: "assets/images/nurs.png"),
    Supervisor(name: "Mona", image: "assets/images/nurs.png"),
    Supervisor(name: "Rana", image: "assets/images/nurs.png"),
    Supervisor(name: "Sara", image: "assets/images/nurs.png"),
    Supervisor(name: "Noor", image: "assets/images/nurs.png"),
    Supervisor(name: "Lama", image: "assets/images/nurs.png"),
    Supervisor(name: "Mona", image: "assets/images/nurs.png"),
    Supervisor(name: "Rana", image: "assets/images/nurs.png"),
  ].obs;

  var assignments = <Assignment>[].obs;

  void next() {
    if (step.value < 2) step.value++;
  }

  void back() {
    if (step.value > 0) step.value--;
  }

  void setDate(DateTime d) => startDate.value = d;

  void setDays(int d) => days.value = d;

  void assign(String supervisor, List<String> tasks) {
    assignments.removeWhere((e) => e.supervisor == supervisor);

    assignments.add(
      Assignment(
        supervisor: supervisor,
        tasks: tasks,
      ),
    );
  }
  bool get isStep1Valid {
    return name.value.isNotEmpty &&
        days.value > 0 &&
        startDate.value != null;
  }

  void submit() {
    Get.snackbar(
      "Success",
      "Schedule Created 🚀",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}