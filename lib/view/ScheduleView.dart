import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/controller/supervisor_shift_controller.dart';
import 'package:supervisors/widgets/%20%20schedule_calendar.dart';


class ScheduleView extends StatelessWidget {
  ScheduleView({super.key});

  final SupervisorShiftsController controller =
  Get.put(SupervisorShiftsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: const Color(0xFFF5EFE7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "My Schedule",
          style: TextStyle(
            color: Color(0xFFA467A7),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: Column(
        children: [

          /// Calendar
          const ScheduleCalendar(),

          const ShiftLegend(),

          _typeSelector(),

        ],
      ),
    );
  }

  Widget _typeSelector() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Row(
          children: [

            Expanded(
              child: ChoiceChip(
                label: const Text("Lecture"),

                selected:
                controller.selectedType.value ==
                    ShiftType.lecture,

                selectedColor:
                const Color(0xFFA467A7),

                labelStyle: TextStyle(
                  color:
                  controller.selectedType.value ==
                      ShiftType.lecture
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),

                onSelected: (_) {
                  controller.changeType(
                    ShiftType.lecture,
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ChoiceChip(
                label: const Text("Housing"),

                selected:
                controller.selectedType.value ==
                    ShiftType.housing,

                selectedColor:
                 Colors.blue,

                labelStyle: TextStyle(
                  color:
                  controller.selectedType.value ==
                      ShiftType.housing
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),

                onSelected: (_) {
                  controller.changeType(
                    ShiftType.housing,
                  );
                },
              ),
            ),

          ],
        ),
      );
    });
  }
}

