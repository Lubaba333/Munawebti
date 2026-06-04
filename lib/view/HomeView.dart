import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/HomeController.dart';
import '../const/app_colors.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 👋 Greeting
                Text(
                  "Hello 👋",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),

                Text(
                  controller.userName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),

                const SizedBox(height: 25),

                /// 🔥 Current Shift Card
                _currentShiftCard(context),

                const SizedBox(height: 25),

                /// ⚡ Quick Actions
                _sectionTitle("Quick Actions", context),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionItem(Icons.check_circle, "Attendance", context),
                    _actionItem(Icons.warning, "Violation", context),
                    _actionItem(Icons.emergency, "Emergency", context),
                  ],
                ),

                const SizedBox(height: 30),

                /// 📅 Today Schedule
                _sectionTitle("Today", context),
                const SizedBox(height: 15),

                ...controller.todaySchedule
                    .map((e) => _scheduleItem(e, context))
                    .toList(),

                const SizedBox(height: 30),

                /// 🔔 Notifications
                _sectionTitle("Notifications", context),
                const SizedBox(height: 15),

                ...controller.notifications
                    .map((n) => _notificationItem(n, context))
                    .toList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 🔥 Section Title
  Widget _sectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }

  /// 💎 Current Shift Card
  Widget _currentShiftCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Current Shift",
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          Obx(() => Text(
                "${controller.currentShift['title']} - ${controller.currentShift['type']}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),

          const SizedBox(height: 5),

          Obx(() => Text(
                controller.currentShift['time'] ?? "",
                style: const TextStyle(color: Colors.white70),
              )),

          const SizedBox(height: 10),

          Row(
            children: const [
              Icon(Icons.circle, color: Colors.red, size: 10),
              SizedBox(width: 6),
              Text("Active", style: TextStyle(color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }

  /// ⚡ Action Item
  Widget _actionItem(IconData icon, String title, BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ],
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  /// 📅 Schedule Item
  Widget _scheduleItem(Map<String, String> item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            item['time'] ?? "",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const Spacer(),
          Text(
            item['place'] ?? "",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔔 Notification
  Widget _notificationItem(String text, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}