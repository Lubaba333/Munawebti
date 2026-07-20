import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notifications_controller.dart';

class NotificationsView extends StatelessWidget {
  final controller = Get.put(NotificationsController());

  NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Notifications".tr)),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return  Center(child: Text("No notifications".tr));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(refresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 100) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: controller.notifications.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.notifications.length) {
                  return controller.isLoadingMore.value
                      ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : const SizedBox();
                }

                final item = controller.notifications[index];
                return ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: item.isRead ? Colors.grey : Color(0xFFA467A7),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight:
                      item.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(item.body),
                  trailing: Text(
                    "${item.createdAt.day}/${item.createdAt.month}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    // لاحقاً: التنقل حسب item.type و item.data
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
}