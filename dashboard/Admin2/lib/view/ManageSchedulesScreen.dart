import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../controller/ScheduleController.dart';

class ManageSchedulesScreen extends StatefulWidget {
  ManageSchedulesScreen({super.key});

  @override
  State<ManageSchedulesScreen> createState() =>
      _ManageSchedulesScreenState();
}

class _ManageSchedulesScreenState extends State<ManageSchedulesScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(ScheduleListController());

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Schedules Management",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [

          /// 🔥 FILTER (كما هو)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButton<int>(
                    isExpanded: true,
                    hint: const Text("Month"),
                    value: controller.selectedMonth.value,
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text("Month ${i + 1}"),
                      );
                    }),
                    onChanged: (val) {
                      controller.selectedMonth.value = val;
                    },
                  )),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Obx(() => DropdownButton<int>(
                    isExpanded: true,
                    hint: const Text("Year"),
                    value: controller.selectedYear.value,
                    items: List.generate(5, (i) {
                      int year = DateTime.now().year - i;
                      return DropdownMenuItem(
                        value: year,
                        child: Text("$year"),
                      );
                    }),
                    onChanged: (val) {
                      controller.selectedYear.value = val;
                    },
                  )),
                ),

                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.selectedMonth.value = null;
                    controller.selectedYear.value = null;
                  },
                )
              ],
            ),
          ),

          /// 🔥 BODY
          Expanded(
            child: Obx(() {
              final list = controller.filteredSchedules;

              /// ❌ EMPTY STATE
              if (list.isEmpty) {
                return _emptyState();
              }

              return GridView.builder(
                itemCount: list.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                ),
                itemBuilder: (context, index) {
                  final schedule = list[index];

                  /// ✨ ظهور انيميشن
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 400 + (index * 80)),
                    opacity: 1,
                    child: AnimatedScale(
                      duration: Duration(milliseconds: 400 + (index * 80)),
                      scale: 1,
                      child: _floatingTile(schedule, index),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: _addButton(),
    );
  }

  // ================= FLOAT ANIMATION =================
  Widget _floatingTile(dynamic schedule, int index) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        double offset =
            sin((_animController.value * 2 * pi) + index) * 6;

        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: _scheduleItem(schedule),
    );
  }

  // ================= ITEM =================
  Widget _scheduleItem(dynamic schedule) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/schedule", arguments: schedule);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [

              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFF8E2DE2), Color(0xFF5A0891)],
                  ).createShader(bounds);
                },
                child: const Icon(
                  Icons.calendar_month,
                  size: 140,
                  color: Colors.white,
                ),
              ),

              /// ✏️ EDIT ICON
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFF5A0891),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            schedule.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            schedule.createdAt,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [

          Icon(Icons.calendar_month,
              size: 80, color: Colors.grey),

          SizedBox(height: 10),

          Text(
            "No Schedules Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Try changing filters or add a new schedule",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ================= ADD BUTTON =================
  Widget _addButton() {
    return GestureDetector(
      onTap: () => Get.toNamed("/program"),
      child: Container(
        width: 65,
        height: 65,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF5A0891)],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}