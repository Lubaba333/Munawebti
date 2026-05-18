// lib/views/room_change_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/models/request_model.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/custom_textfield.dart';
import 'package:studants/widgets/gradient_button.dart';

class RoomChangeView extends StatelessWidget {
  RoomChangeView({super.key});

  final RequestController controller = Get.put(RequestController());
  
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final currentRoomCtrl = TextEditingController();
  final requestedRoomCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildForm()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 10),
          const Text(
            "Room Change Request",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            CustomTextField(
              controller: titleCtrl,
              hint: "Request Title",
              icon: Icons.title,
            ),
            
            CustomTextField(
              controller: descCtrl,
              hint: "Description",
              icon: Icons.description,
            ),
            
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: currentRoomCtrl,
                    hint: "Current Room ID",
                    icon: Icons.meeting_room,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomTextField(
                    controller: requestedRoomCtrl,
                    hint: "Requested Room ID",
                    icon: Icons.meeting_room,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            CustomTextField(
  controller: reasonCtrl,
  hint: "Reason for exit",
  icon: Icons.info_outline,  // ✅ موجود
  
),
            
            const SizedBox(height: 30),
            
            Obx(() => GradientButton(
              text: controller.isLoading.value ? "Submitting..." : "Submit Request",
              onTap: () {
                if (_validateForm()) {
                  final request = RoomChangeRequest(
                    title: titleCtrl.text,
                    description: descCtrl.text,
                    currentRoomId: int.tryParse(currentRoomCtrl.text) ?? 0,
                    requestedRoomId: int.tryParse(requestedRoomCtrl.text) ?? 0,
                    reason: reasonCtrl.text,
                  );
                  controller.createRoomChangeRequest(request);
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (titleCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please enter title",
        backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (currentRoomCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please enter current room ID",
        backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (requestedRoomCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please enter requested room ID",
        backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }
}