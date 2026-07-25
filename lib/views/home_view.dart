import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/notification_controller%20.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/views/dormitory_attendance_view.dart';
import 'package:studants/views/housing_complaints_view.dart';
import 'package:studants/views/lecture_attendance_view.dart';
import 'package:studants/views/rewards_view.dart';
import 'package:studants/views/violations_view.dart';
import 'package:studants/views/warnings_view.dart';
import 'package:studants/widgets/widgets_home/main_card.dart';
import 'package:studants/widgets/widgets_home/service_item.dart';
import 'package:studants/widgets/widgets_home/top_bar.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final HomeController controller = Get.put(HomeController());
  final profileController = Get.put(ProfileController());

  late AnimationController animController;
  late AnimationController entryController;

  final Random _random = Random();
  final List<Offset> _randomOffsets = [];

  @override
  void initState() {
    super.initState();
WidgetsBinding.instance.addObserver(this);
    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 🔔 لما التطبيق يرجع يفتح من الخلفية، نجدد الإشعارات
    if (state == AppLifecycleState.resumed) {
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().getNotifications();
      }
    }
  }
    _generateRandomOffsets(20);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        entryController.forward();
      }
    });
  }

  void _generateRandomOffsets(int count) {
    _randomOffsets.clear();

    for (int i = 0; i < count; i++) {
      final dx =
          (_random.nextBool() ? 1 : -1) * (70 + _random.nextInt(110)).toDouble();

      final dy =
          (_random.nextBool() ? 1 : -1) * (45 + _random.nextInt(120)).toDouble();

      _randomOffsets.add(Offset(dx, dy));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animController.dispose();
    entryController.dispose();
    super.dispose();
  }

  Animation<double> _animationFor(int index) {
    final double start = (index * 0.06).clamp(0.0, 0.70);
    final double end = (start + 0.45).clamp(0.0, 1.0);

    return CurvedAnimation(
      parent: entryController,
      curve: Interval(
        start,
        end,
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _randomEntry({
    required int index,
    required Widget child,
  }) {
    final Offset offset =
        index < _randomOffsets.length ? _randomOffsets[index] : Offset.zero;

    return AnimatedBuilder(
      animation: entryController,
      child: child,
      builder: (context, child) {
        final animation = _animationFor(index);
        final value = animation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              offset.dx * (1 - value),
              offset.dy * (1 - value),
            ),
            child: Transform.scale(
              scale: 0.88 + (0.12 * value),
              child: child,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _services() {
    return [
      _randomEntry(
        index: 5,
        child: ServiceItem(
          icon: Icons.warning_amber_rounded,
          title: "warnings".tr,
          onTap: () => Get.to(() => WarningsView()),
        ),
      ),
      _randomEntry(
        index: 6,
        child: ServiceItem(
          icon: Icons.emoji_events,
          title: "rewards".tr,
          onTap: () => Get.to(() => RewardsView()),
        ),
      ),
      _randomEntry(
        index: 7,
        child: ServiceItem(
          icon: Icons.report_problem,
          title: "housing_complaint".tr,
          onTap: () => Get.to(() => HousingComplaintsView()),
        ),
      ),
      _randomEntry(
        index: 8,
        child: ServiceItem(
          icon: Icons.gavel,
          title: "violations".tr,
          onTap: () => Get.to(() => ViolationsView()),
        ),
      ),
      _randomEntry(
        index: 9,
        child: ServiceItem(
          icon: Icons.home_work_rounded,
          title: "dormitory_attendance_record".tr,
          onTap: () => Get.to(() => DormitoryAttendanceView()),
        ),
      ),
      _randomEntry(
        index: 10,
        child: ServiceItem(
          icon: Icons.fact_check_rounded,
          title: "lecture_attendance_record".tr,
          onTap: () => Get.to(() => LectureAttendanceView()),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _randomEntry(
                index: 0,
                child: const TopBar(),
              ),
              _randomEntry(
                index: 2,
                child: Obx(
                  () => Center(
                    child: Text(
                      profileController.name.value.isEmpty
                          ? "student".tr
                          : profileController.name.value,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _randomEntry(
                index: 3,
                child: MainCard(animController: animController),
              ),
              const SizedBox(height: 30),
              _randomEntry(
                index: 4,
                child: Text(
                  "services".tr,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: _services(),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}