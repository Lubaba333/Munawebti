import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/StudentsController.dart';


class StudentsView extends StatelessWidget {
  final controller = Get.put(StudentsController());

  StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5EFE7),
              Color(0xFFEDE3F3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// 🔥 Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dorm A",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Text(
                              "${controller.filteredStudents.length} Students",
                              style: TextStyle(color: Colors.grey),
                            )),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.group, color: Color(0xFFA467A7))
                  ],
                ),
              ),

              /// 🔍 Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: controller.searchStudent,
                  decoration: InputDecoration(
                    hintText: "Search student...",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              /// 🔥 Session Bar
              _sessionBar(),

              /// 📋 List
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: controller.filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student =
                          controller.filteredStudents[index];

                      return _studentCard(student, index);
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Session Controller UI
  Widget _sessionBar() {
    return Obx(() {
      if (!controller.isSessionActive.value &&
          !controller.isSubmitted.value) {
        return _startButton();
      }

      if (controller.isSessionActive.value) {
        return _activeSessionBar();
      }

      return _submittedBar();
    });
  }

  /// ▶️ Start Button
  Widget _startButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA467A7),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: controller.startSession,
        child: Center(
          child: Text("Start Attendance",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  /// 🔥 Active Session
  Widget _activeSessionBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          Row(
            children: [
              Text("Session Active 🔴",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              TextButton(
                onPressed: () => controller.markAll(true),
                child: Text("All Present"),
              ),
              TextButton(
                onPressed: () => controller.markAll(false),
                child: Text("All Absent"),
              ),
            ],
          ),

          SizedBox(height: 10),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: controller.submitAttendance,
            child: Center(
              child: Text("Submit Attendance",
                  style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  /// ✅ Submitted
  Widget _submittedBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Attendance Submitted"),
          ],
        ),
      ),
    );
  }

  /// 👩‍🎓 Student Card
  Widget _studentCard(Map student, int index) {
    bool isPresent = student['present'];

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPresent
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          /// Avatar
          CircleAvatar(
            backgroundColor: Color(0xFFA467A7),
            child: Text(
              student['name'][0],
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(width: 15),

          /// Name
          Expanded(
            child: Text(
              student['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          /// Toggle
          Switch(
            value: isPresent,
            activeColor: Colors.green,
            onChanged: (_) => controller.toggleAttendance(index),
          ),

          /// ⚠️ Violation
          IconButton(
            icon: Icon(Icons.warning, color: Colors.orange),
            onPressed: () {
              Get.snackbar("Violation", "Add violation");
            },
          )
        ],
      ),
    );
  }
}