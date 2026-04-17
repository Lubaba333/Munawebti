
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/CreateProgramController.dart';
import '../widgets/AppColors.dart';

class CreateScheduleView extends StatelessWidget {
  CreateScheduleView({super.key});

  final c = Get.put(CreateScheduleController());
  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child:  AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Creat Schedule",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),



      body: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 10),
            _StepIndicator(step: c.step.value),
            const SizedBox(height: 10),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) {
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  );
                },
                child: _buildStep(c.step.value),
              ),
            ),

            _BottomBar(controller: c),
          ],
        );
      }),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _StepInfo(key: const ValueKey(0));
      case 1:
        return _StepSupervisors(key: const ValueKey(1));
      case 2:
        return _StepReview(key: const ValueKey(3));
      default:
        return const SizedBox();
    }
  }
}

/// ================= STEP 1 =================
class _StepInfo extends StatelessWidget {
  const _StepInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CreateScheduleController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🧠 GUIDE TEXT (IMPORTANT UX)
          const Text(
            "Please enter schedule details as an admin",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          /// ================= NAME FIELD =================
          _card(
            child:TextField(
              onChanged: (v) => c.name.value = v,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.event_note), // 🔥 أيقونة
                hintText: "Schedule name...",
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// ================= DAYS =================
          _card(
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Number of days: ${c.days.value}",
                    style: const TextStyle(fontSize: 13),
                  ),

                  Slider(
                    min: 1,
                    max: 30,
                    value: c.days.value.toDouble(),
                    onChanged: (v) => c.setDays(v.toInt()),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 12),

          /// ================= DATE PICKER =================
          _card(
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        "Start date: ${c.startDate.value.toString().split(' ').first}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: c.startDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );

                      if (picked != null) {
                        c.setDate(picked);
                      }
                    },
                    icon: const Icon(Icons.date_range, size: 16),
                    label: const Text("Pick"),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// ================= STEP 2 (FLOATING GRID) =================
class _StepSupervisors extends StatefulWidget {
  const _StepSupervisors({super.key});

  @override
  State<_StepSupervisors> createState() => _StepSupervisorsState();
}

class _StepSupervisorsState extends State<_StepSupervisors>
    with SingleTickerProviderStateMixin {
  final c = Get.find<CreateScheduleController>();

  String? selectedSupervisor;

  List<String> selectedTasks = [];

  late AnimationController controller;

  final tasks = ["Checkup", "Injection", "Monitoring", "Report", "Follow-up"];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Assign to $selectedSupervisor",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 🔥 MULTI TASK SELECTION
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tasks.map((t) {
                      final isSelected = selectedTasks.contains(t);

                      return ChoiceChip(
                        label: Text(t),
                        selected: isSelected,
                        onSelected: (v) {
                          setStateSheet(() {
                            if (v) {
                              selectedTasks.add(t);
                            } else {
                              selectedTasks.remove(t);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A0891),
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      if (selectedSupervisor != null &&
                          selectedTasks.isNotEmpty) {
                        c.assign(
                          selectedSupervisor!,
                          List.from(selectedTasks),
                        );
                      }

                      selectedTasks.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
        (constraints.maxWidth / 120).floor().clamp(1, 6);

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: c.supervisors.length,
          itemBuilder: (context, i) {
            final s = c.supervisors[i];
            final isSelected = selectedSupervisor == s.name;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSupervisor = s.name;
                  selectedTasks = [];
                });
                _showForm();
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isSelected ? 1.15 : 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MovingImage(image: s.image),
                    const SizedBox(height: 6),
                    Text(s.name),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// ================= STEP 3 =================
class _StepReview extends StatelessWidget {
  const _StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CreateScheduleController>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          /// ================= TITLE =================
          const Text(
            "Review Schedule",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// ================= LIST =================
          Expanded(
            child: Obx(() {
              if (c.assignments.isEmpty) {
                return const Center(
                  child: Text(
                    "No assignments yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: c.assignments.length,
                itemBuilder: (context, i) {
                  final a = c.assignments[i];

                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),

                              borderRadius: BorderRadius.circular(16),

                              border: Border(
                                left: BorderSide(
                                  color: const Color(0xFF5A0891),
                                  width: 4,
                                ),
                              ),

                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.black.withOpacity(0.05),
                                )
                              ],
                            ),

                            child: Row(
                              children: [

                                /// ================= ICON =================
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5A0891)
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.medical_services,
                                    color: Color(0xFF5A0891),
                                    size: 20,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// ================= NAME =================
                                Expanded(
                                  child: Text(
                                    a.supervisor,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                /// ================= RIGHT SIDE =================
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                  Text(
                                  a.supervisor,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                            const SizedBox(height: 6),

                            Wrap(
                              spacing: 6,
                              children: a.tasks.map((t) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5A0891).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    t,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF5A0891),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 15),

          /// ================= SUBMIT BUTTON =================
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 48,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A0891),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: () {
                  c.submit();
                },

                child: const Text(
                  "Create Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// ================= STEP INDICATOR =================
class _StepIndicator extends StatelessWidget {
  final int step;

  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.edit_note,
      Icons.people,
      Icons.check_circle,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i <= step;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icons[i],
            size: 18,
            color: active ? Colors.white : Colors.grey,
          ),
        );
      }),
    );
  }
}

/// ================= BOTTOM BAR =================
class _BottomBar extends StatelessWidget {
  final CreateScheduleController controller;

  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [

            /// BACK BUTTON
            if (controller.step.value > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.back,
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  label: const Text("Back"),
                ),
              ),

            if (controller.step.value > 0)
              const SizedBox(width: 10),

            /// NEXT BUTTON (SMALL + WHITE TEXT)
            Expanded(
              child: Align(
                alignment: Alignment.center, // 🔥 يمنع التمدد
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 42,

                  child: ElevatedButton.icon(
                    onPressed: controller.step.value == 0
                        ? (controller.isStep1Valid ? controller.next : null)
                        : controller.step.value == 2
                        ? controller.submit
                        : controller.next,

                    icon: const Icon(Icons.arrow_forward_ios, size: 14),

                    label: Text(
                      controller.step.value == 3 ? "Submit" : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.step.value == 0 &&
                          !controller.isStep1Valid
                          ? Colors.grey
                          : AppColors.primary,

                      padding: EdgeInsets.zero, // 🔥 يمنع التمدد الداخلي
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

/// ================= GLASS CARD =================
Widget _card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          blurRadius: 10,
          color: Colors.black.withOpacity(0.05),
        )
      ],
    ),
    child: child,
  );
}


class _MovingImage extends StatefulWidget {
  final String image;

  const _MovingImage({required this.image});

  @override
  State<_MovingImage> createState() => _MovingImageState();
}

class _MovingImageState extends State<_MovingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnim;
  late Animation<double> opacityAnim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    opacityAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnim.value, // 🔥 smooth pulse

          child: Opacity(
            opacity: opacityAnim.value, // 🔥 subtle fade

            child: child,
          ),
        );
      },

      /// 👇 الصورة ثابتة = no blur
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.image,
            width: 75,
            height: 75,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}