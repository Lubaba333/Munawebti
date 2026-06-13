import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/views/EmergencyListView.dart';
import 'package:studants/views/SettingsDrawerview.dart';
import 'package:studants/views/dormitory_attendance_view.dart';
import 'package:studants/views/housing_complaints_view.dart';
import 'package:studants/views/lectures_view.dart';
import 'package:studants/views/my_requests_view.dart';
import 'package:studants/views/rewards_view.dart';
import 'package:studants/views/violations_view.dart';
import 'package:studants/views/warnings_view.dart';
import 'package:studants/widgets/widgets_home/main_card.dart';
import 'package:studants/widgets/widgets_home/service_item.dart';
import 'package:studants/widgets/widgets_home/top_bar.dart';
import '../controllers/home_controller.dart';
import '../../../utlis/app_colors.dart';
import '../widgets/widgets_home/bottom_nav.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  final profileController = Get.put(ProfileController());

  late AnimationController animController;
  late AnimationController entryController;

  final Random _random = Random();
  final List<Offset> _randomOffsets = [];

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

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
      final dx = (_random.nextBool() ? 1 : -1) *
          (70 + _random.nextInt(110)).toDouble();

      final dy = (_random.nextBool() ? 1 : -1) *
          (45 + _random.nextInt(120)).toDouble();

      _randomOffsets.add(Offset(dx, dy));
    }
  }

  @override
  void dispose() {
    animController.dispose();
    entryController.dispose();
    super.dispose();
  }

void _onNavItemTapped(int index) async {
  if (index == _currentIndex) return;

  setState(() => _currentIndex = index);

  switch (index) {
    case 0:
      await Get.to(() => LecturesView());
      break;

    case 1:
      setState(() => _currentIndex = 1);
      return;

    case 2:
      await Get.to(() => MyRequestsView());
      break;

    case 3:
      await Get.to(() => EmergencyListView());
      break;
  }

  if (mounted) {
    setState(() => _currentIndex = 1);
  }
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
          title: "تنبيهاتي",
          onTap: () => Get.to(() => WarningsView()),
        ),
      ),
      _randomEntry(
        index: 6,
        child: ServiceItem(
          icon: Icons.emoji_events,
          title: "مكافآتي",
          onTap: () => Get.to(() => RewardsView()),
        ),
      ),
      _randomEntry(
        index: 7,
        child: ServiceItem(
          icon: Icons.report_problem,
          title: "شكوى سكن",
          onTap: () => Get.to(() => HousingComplaintsView()),
        ),
      ),
      _randomEntry(
        index: 8,
        child: ServiceItem(
          icon: Icons.gavel,
          title: "مخالفات",
          onTap: () => Get.to(() => ViolationsView()),
        ),
      ),
      _randomEntry(
        index: 9,
        child: ServiceItem(
          icon: Icons.menu_book,
          title: "حضور السكن",
          onTap: () => Get.to(() => DormitoryAttendanceView()),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: SettingsDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _randomEntry(
                index: 0,
                child: const TopBar(),
              ),

              const SizedBox(height: 20),

              _randomEntry(
                index: 1,
                child: Text(
                  "مرحباً 👋",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              _randomEntry(
                index: 2,
                child: Obx(
                  () => Text(
                    controller.studentName.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                child: const Text(
                  "الخدمات",
                  style: TextStyle(
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
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}