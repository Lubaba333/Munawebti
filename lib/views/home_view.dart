import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../utlis/app_colors.dart';

import '../widgets/top_bar.dart';
import '../widgets/main_card.dart';
import '../widgets/service_item.dart';
import '../widgets/notification_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/settings_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {

  final HomeController controller = Get.put(HomeController());
  late AnimationController animController;

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,
      drawer: SettingsDrawer(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔝 TOP BAR
              const TopBar(),

              const SizedBox(height: 20),

              /// 👋 WELCOME
              const Text(
                "مرحباً 👋",
                style: TextStyle(color: Colors.grey),
              ),

              Obx(() => Text(
                    controller.studentName.value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple,
                    ),
                  )),

              const SizedBox(height: 25),

              /// 💜 MAIN CARD
              MainCard(animController: animController),

              const SizedBox(height: 30),

              /// 🧩 SERVICES
              const Text(
                "الخدمات",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                children: const [
                  ServiceItem(icon: Icons.calendar_today, title: "إجازة"),
                  ServiceItem(icon: Icons.meeting_room, title: "نقل غرفة"),
                  ServiceItem(icon: Icons.school, title: "العلامات"),
                  ServiceItem(icon: Icons.warning, title: "ملاحظات"),
                ],
              ),

              const SizedBox(height: 25),

              /// 🔔 NOTIFICATIONS
              const NotificationCard(),
            ],
          ),
        ),
      ),

      /// 🔻 BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }
}