import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/attendance_history_controller.dart';
import '../services/api_service.dart';

class AttendanceHistoryView extends GetView<AttendanceHistoryController> {
  AttendanceHistoryView({super.key});

  final AttendanceHistoryController controller = Get.put(
    AttendanceHistoryController(
      ApiService(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text(
          "Attendance History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        if (controller.history.isEmpty) {
          return const Center(
            child: Text(
              "No Attendance History",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryLight,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [

              //--------------------------------------------------
              // Header Card
              //--------------------------------------------------

              Container(
                margin: const EdgeInsets.only(bottom: 22),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.mainGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(.30),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.fact_check_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Attendance Records",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "${controller.history.length} attendance records found",
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //--------------------------------------------------
              // List
              //--------------------------------------------------

              ...controller.history.map((item) {
                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.white,
                        AppColors.backgroundLight,
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withOpacity(.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [

                        //------------------------------------------------
                        // Header
                        //------------------------------------------------

                        Row(
                          children: [

                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                              AppColors.light,
                              child: const Icon(
                                Icons.person_rounded,
                                color:
                                AppColors.primary,
                                size: 32,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [

                                  Text(
                                    item.student.fullName,
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      fontSize: 18,
                                      color: AppColors
                                          .textDark,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 5),

                                  Text(
                                    item.student
                                        .studentIdentifier,
                                    style:
                                    const TextStyle(
                                      color: AppColors
                                          .textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration:
                              BoxDecoration(
                                gradient:
                                const LinearGradient(
                                  colors: AppColors
                                      .buttonGradient,
                                ),
                                borderRadius:
                                BorderRadius
                                    .circular(30),
                              ),
                              child: const Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [

                                  Icon(
                                    Icons
                                        .check_circle,
                                    color:
                                    Colors.white,
                                    size: 16,
                                  ),

                                  SizedBox(width: 5),

                                  Text(
                                    "Recorded",
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        const Divider(
                          color: AppColors.light,
                        ),

                        const SizedBox(height: 15),

                        _buildInfoTile(
                          Icons.school,
                          "Shift Type",
                          item.shiftType,
                        ),

                        _buildInfoTile(
                          Icons.calendar_month,
                          "Date",
                          item.shift.shiftDate,
                        ),

                        _buildInfoTile(
                          Icons.schedule,
                          "Time",
                          "${item.shift.fromHour} - ${item.shift.toHour}",
                        ),

                        _buildInfoTile(
                          Icons.check_circle_outline,
                          "Recorded At",
                          item.attendanceRecordedAt,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
  Widget _buildInfoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.light,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [

          //----------------------------------
          // Icon
          //----------------------------------

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.buttonGradient,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 15),

          //----------------------------------
          // Text
          //----------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}