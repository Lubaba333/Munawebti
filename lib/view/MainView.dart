import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/notifications_controller.dart';
import 'ChatListView.dart';
import 'HomeView.dart';
import 'NotificationsView.dart';
import 'ProfileView.dart';
import 'ScheduleView.dart';
import 'SettingsView.dart';
import 'StudentsView.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final RxInt currentIndex = 0.obs;

  final pages = [
    HomeView(),
    ScheduleView(),
    StudentsView(),
    ChatListView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// 🔝 APP BAR (FIXED)
    appBar: AppBar(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  elevation: 0,

  iconTheme: IconThemeData(
    color: Theme.of(context).colorScheme.onBackground,
  ),

  actions: [
    Obx(() {
      final notifController = Get.find<NotificationsController>();
      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon:  Icon(Icons.notifications),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => Get.to(() => NotificationsView()),
          ),
          if (notifController.unreadCount.value > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  notifController.unreadCount.value > 99
                      ? '99+'
                      : '${notifController.unreadCount.value}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    }),

    IconButton(
      icon: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        Get.to(() => ProfileView());
      },
    ),
  ],
),
      /// 🔄 BODY
      body: Obx(() => pages[currentIndex.value]),

      /// 🔻 BOTTOM NAV
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          currentIndex: currentIndex.value,
          onTap: (index) => currentIndex.value = index,
        ),
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "home".tr;
      case 1:
        return "schedule".tr;
      case 2:
        return "students".tr;
      case 3:
        return "chat".tr;
      case 4:
        return "settings".tr;
      default:
        return "";
    }
  }
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home, "home".tr, 0),
          _navItem(context, Icons.calendar_today, "schedule".tr, 1),
          _navItem(context, Icons.school, "students".tr, 2),
          _navItem(context, Icons.chat_bubble_outline, "chat".tr, 3),
          _navItem(context, Icons.settings, "settings".tr, 4),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          ],
        ),
      ),
    );
  }
}




