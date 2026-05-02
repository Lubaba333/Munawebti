import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/HomeController.dart';
import 'package:my_app/view/ChatView.dart';
import 'package:my_app/view/ProfileView.dart';
import 'package:my_app/view/RequestsView.dart';
import 'package:my_app/view/ScheduleView.dart';
import 'package:my_app/view/StudentsView.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());

  final pages = [
    ScheduleView(),
    StudentsView(),
    RequestsView(),
    ProfileView(),
    ChatView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: pages[controller.currentIndex.value],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            selectedItemColor: Color(0xFFA467A7),
            unselectedItemColor: Colors.grey,

            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: "Schedule"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "Students"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.request_page), label: "Requests"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
                  BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
                  
            ],
          ),
        ));
  }
}