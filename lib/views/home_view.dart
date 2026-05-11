import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/views/SettingsDrawerview.dart';
import 'package:studants/views/SwapOrMoveView.dart';
import 'package:studants/views/swap_view.dart';
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

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {

  final HomeController controller = Get.put(HomeController());
  final profileController = Get.put(ProfileController());
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
      
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

Obx(() => Text(controller.studentName.value)),

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
  children: [
    const ServiceItem(icon: Icons.calendar_today, title: "إجازة"),

   ServiceItem(
  icon: Icons.meeting_room,
  title: "نقل غرفة",
  onTap: () {
    Get.to(() => const SwapOrMoveView());
  },
),

    const ServiceItem(icon: Icons.school, title: "العلامات"),
    const ServiceItem(icon: Icons.warning, title: "ملاحظات"),
  ],
),

              const SizedBox(height: 25),

              /// 🔔 NOTIFICATIONS
             
            ],
          ),
        ),
      ),

      /// 🔻 BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }
}