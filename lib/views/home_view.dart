import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/views/SettingsDrawerview.dart';
import 'package:studants/views/SwapOrMoveView.dart';
import 'package:studants/views/lectures_view.dart';
import 'package:studants/views/my_requests_view.dart';
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
  
  /// 🎯 الفهرس الحالي للـ BottomNav (1 = الرئيسية في الوسط)
  int _currentIndex = 1;

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

 void _onNavItemTapped(int index) {
  if (index == _currentIndex) return;

  setState(() => _currentIndex = index);

  switch (index) {
    case 0:
      // TODO: صفحة المحاضراتServiceItem(
 Get.to(() =>  LecturesView());
      break;

    case 1:
      // نفس الصفحة (Home)
      break;

    case 2:
     Get.to(() =>  MyRequestsView());
      break;
  }
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

              /// 👋 HEADER
              Text(
                "مرحباً 👋",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 5),

              Obx(() => Text(
                    controller.studentName.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                children: [
                  
                 
                  
                  ServiceItem(
                    icon: Icons.home, 
                    title: "سكني", 
                    onTap: () => Get.to(() => const SwapOrMoveView()),
                  ),
                  
               
                  
                  ServiceItem(
                    icon: Icons.warning_amber_rounded, 
                    title: "تنبيهاتي", 
                    onTap: () => Get.to(() => const SwapOrMoveView()),
                  ),
                  
                  ServiceItem(
                    icon: Icons.emoji_events, 
                    title: "إنجازاتي", 
                    onTap: () => Get.to(() => const SwapOrMoveView()),
                  ),
                  
                  ServiceItem(
                    icon: Icons.report_problem, 
                    title: "شكوى سكن", 
                    onTap: () => Get.to(() => const SwapOrMoveView()),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// 🔔 NOTIFICATIONS
              // (يمكن إضافة محتوى هنا مستقبلاً)
             
            ],
          ),
        ),
      ),

      /// 🔻 BOTTOM NAV - الجديد مع النصوص والزر البارز
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}