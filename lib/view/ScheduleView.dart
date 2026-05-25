import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/const/app_colors.dart';
import '../controller/ScheduleController.dart';

class ScheduleView extends StatelessWidget {
  ScheduleView({super.key});

  final controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          "Supervisor Schedule",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Header
            _buildHeader(),

            const SizedBox(height: 15),

            /// Table
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.schedules.length,
                  itemBuilder: (context, index) {

                    final dayData =
                        controller.schedules[index];

                    return _buildDayRow(dayData);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      children: [

        /// Day title
        Container(
          width: 90,
          alignment: Alignment.center,
          child: Text(
            "Day",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),

        Expanded(
          child: Row(
            children: controller.timeSlots.map((time) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.buttonGradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  /// ================= DAY ROW =================
  Widget _buildDayRow(Map<String, dynamic> dayData) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Day Name
          Container(
            width: 50,
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                dayData["day"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Schedule Slots
          Expanded(
            child: Row(
              children: List.generate(
                dayData["slots"].length,
                (index) {

                  final slot =
                      dayData["slots"][index];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {

                        /// مستقبلاً:
                        /// تفاصيل المادة
                        /// تعديل
                        /// API
                      },
                      child: Container(
                        height: 120,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: controller.getCardColor(
                              slot["type"]),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            /// Top indicator
                            Container(
                              width: 35,
                              height: 6,
                              decoration: BoxDecoration(
                                color:
                                    controller.getTextColor(
                                        slot["type"]),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),

                            /// Title
                            Text(
                              slot["title"],
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color:
                                    AppColors.textDark,
                              ),
                            ),

                            /// Type
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: controller
                                    .getTextColor(
                                        slot["type"])
                                    .withOpacity(0.12),
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                              ),
                              child: Text(
                                slot["type"],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w600,
                                  color: controller
                                      .getTextColor(
                                          slot["type"]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}