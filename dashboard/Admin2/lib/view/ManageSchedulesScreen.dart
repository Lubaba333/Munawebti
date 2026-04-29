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

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child: AppBar(
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

          /// ================= FILTER =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      dropdownColor: theme.colorScheme.surface,
                      value: controller.selectedMonth.value,
                      hint: Text("Month", style: TextStyle(color: theme.hintColor)),
                      underline: const SizedBox(),
                      items: List.generate(12, (i) {
                        return DropdownMenuItem(
                          value: i + 1,
                          child: Text("Month ${i + 1}"),
                        );
                      }),
                      onChanged: (val) {
                        controller.selectedMonth.value = val;
                      },
                    ),
                  )),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      dropdownColor: theme.colorScheme.surface,
                      value: controller.selectedYear.value,
                      hint: Text("Year", style: TextStyle(color: theme.hintColor)),
                      underline: const SizedBox(),
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
                    ),
                  )),
                ),

                IconButton(
                  icon: Icon(Icons.clear, color: theme.iconTheme.color),
                  onPressed: () {
                    controller.selectedMonth.value = null;
                    controller.selectedYear.value = null;
                  },
                )
              ],
            ),
          ),

          /// ================= BODY =================
          Expanded(
            child: Obx(() {
              final list = controller.filteredSchedules;

              if (list.isEmpty) {
                return _emptyState(context);
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
                    child: _scheduleItem(context, schedule),
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: _addButton(context),
    );
  }

  // ================= ITEM =================
  Widget _scheduleItem(BuildContext context, dynamic schedule) {

    final theme = Theme.of(context);

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
                    colors: [
                      Color(0xFF8E2DE2),
                      Color(0xFF5A0891),
                    ],
                  ).createShader(bounds);
                },
                child: const Icon(
                  Icons.calendar_month,
                  size: 140,
                  color: Colors.white, // مهم تثبيت الأبيض هنا
                ),
              ),

              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            schedule.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            schedule.createdAt,
            style: TextStyle(
              color: theme.hintColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY =================
  Widget _emptyState(BuildContext context) {

    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(Icons.calendar_month,
              size: 80, color: theme.hintColor),

          const SizedBox(height: 10),

          Text(
            "No Schedules Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Try changing filters or add a new schedule",
            style: TextStyle(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  // ================= ADD BUTTON =================
  Widget _addButton(BuildContext context) {

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.toNamed("/program"),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}