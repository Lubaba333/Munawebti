import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/custom_textfield.dart';
import 'package:studants/widgets/gradient_button.dart';

class RoomTransferView extends StatefulWidget {
  const RoomTransferView({super.key});

  @override
  State<RoomTransferView> createState() => _RoomTransferViewState();
}

class _RoomTransferViewState extends State<RoomTransferView> {
  final RequestController controller = Get.isRegistered<RequestController>()
      ? Get.find<RequestController>()
      : Get.put(RequestController());

  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getCurrentStudentRoom();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  String _unitArabicName(String? name) {
    switch (name) {
      case "Building A":
        return "building_1".tr;
      case "Building B":
        return "building_2".tr;
      case "Building C":
        return "building_3".tr;
      default:
        return name ?? "not_specified".tr;
    }
  }

  String _unitNameFromRoom(dynamic room) {
    final unit = room['dormitory_unit'];
    final rawName = unit != null
        ? unit['name']?.toString()
        : room['dormitory_unit_name']?.toString();

    return _unitArabicName(rawName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(child: _form()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Text(
              "room_transfer".tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Obx(() {
        if (controller.isLoadingCurrentRoom.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentRoom = controller.currentRoom.value;

        if (currentRoom == null) {
          return Center(
            child: Text(
              "current_room_not_loaded_resident".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.move_up,
                color: AppColors.darkPurple,
                size: 76,
              ),
              const SizedBox(height: 12),
              Text(
                "room_transfer_desc".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              _currentRoomCard(currentRoom),
              const SizedBox(height: 20),
              CustomTextField(
                controller: reasonController,
                hint: "room_transfer_reason".tr,
                icon: Icons.edit_note,
              ),
              const SizedBox(height: 24),
              Obx(
                () => GradientButton(
                  text: "send_room_transfer".tr,
                  isLoading: controller.isSubmitting.value,
                  onTap: () {
                    controller.createAnyAvailableRoomRequest(
                      reason: reasonController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _currentRoomCard(Map<String, dynamic> room) {
    final unitName = _unitNameFromRoom(room);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softLavender,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.mauve.withOpacity(.4)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.home, color: AppColors.darkPurple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "current_room".tr,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${"room".tr}: ${room['room_number']}  |  ${"unit".tr}: $unitName",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}