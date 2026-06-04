import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/StudentsController.dart';
import '../const/app_colors.dart';

class StudentsView extends StatelessWidget {
  final controller = Get.put(StudentsController());

  StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 HEADER
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
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      Obx(() => Text(
                            "${controller.filteredStudents.length} Students",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          )),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.group, color: AppColors.primary)
                ],
              ),
            ),

            /// 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: controller.searchStudent,
                decoration: InputDecoration(
                  hintText: "Search student...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 SESSION BAR
            _sessionBar(),

            /// 📋 LIST
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = controller.filteredStudents[index];
                    return _studentCard(student, index, context);
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  // ================= SESSION BAR =================
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

  // ▶️ START
  Widget _startButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: controller.startSession,
        child: const Center(
          child: Text(
            "Start Attendance",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // 🔥 ACTIVE SESSION
  Widget _activeSessionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [

          Row(
            children: [
              Text(
                "Session Active 🔴",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(Get.context!)
                      .colorScheme
                      .onBackground,
                ),
              ),

              const Spacer(),

              IconButton(
                icon: Icon(Icons.qr_code_scanner,
                    color: AppColors.primary),
                onPressed: () {},
              ),

              TextButton(
                onPressed: () => controller.markAll(true),
                child: const Text("All Present"),
              ),

              TextButton(
                onPressed: () => controller.markAll(false),
                child: const Text("All Absent"),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: controller.submitAttendance,
            child: const Center(
              child: Text(
                "Submit Attendance",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ✅ SUBMITTED
  Widget _submittedBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Attendance Submitted"),
          ],
        ),
      ),
    );
  }

  // 👩‍🎓 STUDENT CARD
  Widget _studentCard(Map student, int index, BuildContext context) {
    bool isPresent = student['present'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPresent
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              student['name'][0],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              student['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),

          Switch(
            value: isPresent,
            activeColor: Colors.green,
            onChanged: (_) => controller.toggleAttendance(index),
          ),

          IconButton(
            icon: const Icon(Icons.warning, color: Colors.orange),
            onPressed: () {
              Get.snackbar("Violation", "Add violation");
            },
          )
        ],
      ),
    );
  }
}