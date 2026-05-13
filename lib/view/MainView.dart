import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import 'ChatView.dart';
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
     ChatView(),
    SettingsView(),
   
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔝 AppBar
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Obx(() => Text(
              _getTitle(currentIndex.value),
              style: TextStyle(color: AppColors.textDark),
            )),

        actions: [
          /// 🔔 Notifications
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: AppColors.primary),
                // Positioned(
                //   right: 0,
                //   child: CircleAvatar(
                //     radius: 5,
                //    backgroundColor: Colors.red,
                //   ),
                // )
              ],
            ),
            onPressed: () {
              Get.to(() => NotificationsView());
            },
          ),

          /// 👤 Profile
          IconButton(
            icon: Icon(Icons.person, color: AppColors.primary),
            onPressed: () {
              Get.to(() => ProfileView());
            },
          ),
        ],
      ),

      /// 🔄 Body
      body: Obx(() => pages[currentIndex.value]),

      /// 🔻 Custom Bottom Nav
      bottomNavigationBar: Obx(() => CustomBottomNav(
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
          )),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Schedule";
      case 2:
        return "Students";
      case 3:
        return "Chat";
      case 4:
        return "Settings";
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
      margin: const EdgeInsets.all(10), // 🔥 Floating
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(35), // 🔥 Rounded
        boxShadow: [
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

          _navItem(Icons.home, "Home", 0),
          _navItem(Icons.calendar_today, "Schedule", 1),
          _navItem(Icons.school, "Students", 2),
          _navItem(Icons.chat_bubble_outline, "Chat", 3),
          _navItem(Icons.settings, "Settings", 4),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : Colors.grey,
            ),

            SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive
                    ? AppColors.primary
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}