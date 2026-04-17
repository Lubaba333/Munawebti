import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/DashboardController.dart';
import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';


class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
          const SlideSidebar(),

          Expanded(
            child: Column(
              children: [
                const Topbar(),

                Expanded(
                  child: Obx(() {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: controller
                          .pages[controller.selectedIndex.value],
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}