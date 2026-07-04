import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/views/exit_permission_view.dart';
import 'package:studants/views/room_exchange_view.dart';
import 'package:studants/views/room_transfer_view.dart';
import 'package:studants/views/specific_room_change_view.dart';
import 'package:studants/views/sent_requests_tab.dart';
import 'package:studants/views/incoming_requests_tab.dart';

class MyRequestsView extends StatefulWidget {
  final bool showBackButton;

  const MyRequestsView({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<MyRequestsView> createState() => _MyRequestsViewState();
}

class _MyRequestsViewState extends State<MyRequestsView>
    with SingleTickerProviderStateMixin {
  final RequestController controller = Get.isRegistered<RequestController>()
      ? Get.find<RequestController>()
      : Get.put(RequestController());

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getCurrentStudentRoom();
      await controller.getMyRequests();
      await controller.getReceivedRequests();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: GestureDetector(
        onTap: _showNewRequestSheet,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.darkMainGradient : AppColors.mainGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(.28)
                    : AppColors.darkPurple.withOpacity(.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "new_request".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              _tabs(),
              Expanded(child: _body(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          if (widget.showBackButton)
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(.18)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          if (widget.showBackButton) const SizedBox(width: 12),
          Expanded(
            child: Text(
              "my_requests".tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    final isDark = Get.isDarkMode;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDark ? .13 : .18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(isDark ? .10 : .05),
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: isDark ? AppColors.mauve.withOpacity(.25) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: isDark ? Colors.white : AppColors.darkPurple,
        unselectedLabelColor: Colors.white70,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: "my_requests".tr),
          Tab(text: "incoming".tr),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.22)
                : AppColors.deepPurple.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: TabBarView(
        controller: tabController,
        children: [
          SentRequestsTab(controller: controller),
          IncomingRequestsTab(controller: controller),
        ],
      ),
    );
  }

  void _showNewRequestSheet() {
    final isDark = Get.isDarkMode;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: isDark ? AppColors.mauve.withOpacity(.16) : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.mauve.withOpacity(.45)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "create_new_request".tr,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Get.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            _sheetItem(
              Icons.exit_to_app,
              "exit_from_dormitory_permission".tr,
              () {
                Get.back();
                Get.to(() => ExitPermissionView());
              },
            ),
            _sheetItem(
              Icons.meeting_room,
              "room_change_without_alternative".tr,
              () {
                Get.back();
                Get.to(() => const SpecificRoomChangeView());
              },
            ),
            _sheetItem(
              Icons.swap_horiz,
              "room_exchange_with_student".tr,
              () {
                Get.back();
                Get.to(() => const RoomExchangeView());
              },
            ),
            _sheetItem(
              Icons.move_up,
              "transfer_to_any_available_room".tr,
              () {
                Get.back();
                Get.to(() => const RoomTransferView());
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _sheetItem(IconData icon, String title, VoidCallback onTap) {
    final isDark = Get.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.07)
            : AppColors.softLavender.withOpacity(.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.mauve.withOpacity(.18) : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              isDark ? AppColors.mauve.withOpacity(.16) : Colors.white,
          child: Icon(
            icon,
            color: isDark ? AppColors.mauve : AppColors.darkPurple,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Get.textTheme.titleMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? AppColors.mauve : AppColors.darkPurple,
        ),
      ),
    );
  }
}