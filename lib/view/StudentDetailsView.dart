import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ReportsController.dart';
import 'package:supervisors/controller/RewardsController.dart';
import 'package:supervisors/controller/StudentActionsController.dart';
import 'package:supervisors/controller/StudentDetailsController.dart';
import 'package:supervisors/controller/ViolationsController.dart';
import '../controller/warning_controller.dart';

import '../widgets/student_header.dart';
import '../widgets/student_info_tab.dart';
import '../widgets/student_attendance_tab.dart';
import '../widgets/student_history_tab.dart';
import '../widgets/student_actions_sheet.dart';


class StudentDetailsView extends StatelessWidget {

  StudentDetailsView({super.key});

  final StudentDetailsController controller =
  Get.put(StudentDetailsController());

  final StudentActionsController
  actionsController =
  Get.put(StudentActionsController());

  final WarningsController
  warningController =
  Get.put(WarningsController());

  final violationsController =
  Get.put(
    ViolationsController(),
  );

  final RewardsController rewardsController =
  Get.put(RewardsController());

  final ReportsController reportsController =
  Get.put(ReportsController());

  @override
  Widget build(BuildContext context) {

    final student = controller.student;
    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      warningController
          .getStudentWarnings(
        student.id,
      );

      violationsController
          .getStudentViolations(
        student.id,
      );

      rewardsController
          .getStudentRewards(
        student.id,
      );

      reportsController
          .getStudentReports(
        student.id,
      );
    });

    return Scaffold(

      backgroundColor:
      AppColors.background,

      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        AppColors.primary,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        onPressed: () {

          Get.bottomSheet(

            StudentActionsSheet(
              student: student,
            ),

            isScrollControlled:
            true,

            backgroundColor:
            Colors.white,
          );
        },
      ),

      body: NestedScrollView(

        headerSliverBuilder:
            (context, innerBoxIsScrolled) {

          return [

            SliverAppBar(

              expandedHeight: 280,

              pinned: true,

              backgroundColor:
              AppColors.primary,

              flexibleSpace:
              FlexibleSpaceBar(

                background:
                StudentHeader(
                  student: student,
                ),
              ),

              bottom: TabBar(

                controller:
                controller
                    .tabController,

                indicatorColor:
                Colors.white,

                labelColor:
                Colors.white,

                unselectedLabelColor:
                Colors.white70,

                tabs: const [

                  Tab(
                    text:
                    "المعلومات",
                  ),

                  Tab(
                    text:
                    "الحضور",
                  ),

                  Tab(
                    text:
                    "السجل",
                  ),
                ],
              ),
            ),
          ];
        },

        body: TabBarView(

          controller:
          controller.tabController,

          children: [

            StudentInfoTab(
              student: student,
            ),

            StudentAttendanceTab(
              studentId:
              student.id,
            ),

            const StudentHistoryTab(),
          ],
        ),
      ),
    );
  }
}



