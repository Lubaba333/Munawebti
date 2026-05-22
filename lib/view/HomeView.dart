import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../const/app_colors.dart';
import '../controller/HomeController.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 👋 Greeting
                Text(
                  "Hello 👋",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),

                Text(
                  controller.userName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                SizedBox(height: 25),

                /// 🔥 Current Shift Card (Highlight)
                _currentShiftCard(),

                SizedBox(height: 25),

                /// ⚡ Quick Actions
                _sectionTitle("Quick Actions"),
                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionItem(Icons.check_circle, "Attendance"),
                    _actionItem(Icons.warning, "Violation"),
                    _actionItem(Icons.emergency, "Emergency"),
                  ],
                ),

                SizedBox(height: 30),

                /// 📅 Today Schedule
                _sectionTitle("Today"),
                SizedBox(height: 15),

                ...controller.todaySchedule
                    .map((e) => _scheduleItem(e))
                    .toList(),

                SizedBox(height: 30),

                /// 🔔 Notifications
                _sectionTitle("Notifications"),
                SizedBox(height: 15),

                ...controller.notifications
                    .map((n) => _notificationItem(n))
                    .toList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 🔥 Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  /// 💎 Current Shift Card (Modern)
  Widget _currentShiftCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Current Shift",
            style: TextStyle(color: AppColors.textLight),
          ),

          SizedBox(height: 10),

          Obx(() => Text(
                "${controller.currentShift['title']} - ${controller.currentShift['type']}",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),

          SizedBox(height: 5),

          Obx(() => Text(
                controller.currentShift['time'] ?? "",
                style: TextStyle(color: AppColors.textLight),
              )),

          SizedBox(height: 10),

          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
              Text(
                "Active",
                style: TextStyle(color: AppColors.textLight),
              )
            ],
          )
        ],
      ),
    );
  }

  /// ⚡ Action Item
  Widget _actionItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8)
            ],
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  /// 📅 Schedule Item
  Widget _scheduleItem(Map<String, String> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppColors.primary),
          SizedBox(width: 10),
          Text(item['time'] ?? ""),
          Spacer(),
          Text(item['place'] ?? "",
              style: TextStyle(color: AppColors.textLight)),
        ],
      ),
    );
  }

  /// 🔔 Notification
  Widget _notificationItem(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}