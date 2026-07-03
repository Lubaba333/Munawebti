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
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: _showNewRequestSheet,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkPurple.withOpacity(.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
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
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              _tabs(),
              Expanded(child: _body()),
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
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          if (widget.showBackButton) const SizedBox(width: 8),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: AppColors.darkPurple,
        unselectedLabelColor: Colors.white,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: "my_requests".tr),
          Tab(text: "incoming".tr),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "create_new_request".tr,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 20),
            _sheetItem(Icons.exit_to_app, "exit_from_dormitory_permission".tr,
                () {
              Get.back();
              Get.to(() => ExitPermissionView());
            }),
            _sheetItem(Icons.meeting_room,
                "room_change_without_alternative".tr, () {
              Get.back();
              Get.to(() => const SpecificRoomChangeView());
            }),
            _sheetItem(Icons.swap_horiz, "room_exchange_with_student".tr, () {
              Get.back();
              Get.to(() => const RoomExchangeView());
            }),
            _sheetItem(Icons.move_up, "transfer_to_any_available_room".tr, () {
              Get.back();
              Get.to(() => const RoomTransferView());
            }),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _sheetItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.softLavender.withOpacity(.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: AppColors.darkPurple),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}