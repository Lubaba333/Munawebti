import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:studants/controllers/housing_attendance_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/gradient_button.dart';

class HousingAttendanceView extends StatelessWidget {
  HousingAttendanceView({super.key});

  final controller = Get.put(HousingAttendanceController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUpcomingShift();
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                  ),
                  child: RefreshIndicator(
                    color: AppColors.mauve,
                    onRefresh: () => controller.getUpcomingShift(),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return _refreshableScroll(
                          context,
                          const Center(child: CircularProgressIndicator(color: AppColors.mauve)),
                        );
                      }
                      if (controller.errorMessage.value.isNotEmpty) {
                        return _refreshableScroll(context, _errorState(context));
                      }
                      if (!controller.hasUpcomingShift) {
                        return _refreshableScroll(context, _emptyState(context));
                      }

                      return _buildCleanContent(context, controller.upcomingShift.value!);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// يلف أي محتوى (لودينج/خطأ/فاضي) بـ ScrollView قابل للسحب حتى لو
  /// المحتوى أصغر من الشاشة، عشان RefreshIndicator يقدر يشتغل بالسحب دايماً.
  Widget _refreshableScroll(BuildContext context, Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.home_rounded, color: Colors.white, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "record housing attendance".tr,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14),
            ),
            const SizedBox(height: 24),
            GradientButton(text: "retry".tr, onTap: controller.getUpcomingShift),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60, color: Get.isDarkMode ? AppColors.mauve : AppColors.darkPurple),
            const SizedBox(height: 16),
            Text(
              "no_upcoming_housing_shift".tr,
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanContent(BuildContext context, Map<String, dynamic> shift) {
    String unitName = shift['dormitory_name']?.toString() ?? 'housing_unit_unknown'.tr;

    final roomData = shift['room'];
    String roomNumber = 'room_unknown'.tr;
    if (roomData is Map) {
      roomNumber = roomData['room_number']?.toString() ?? 'room_unknown'.tr;
    } else if (roomData is String) {
      roomNumber = roomData;
    }

    String dateFormatted = _formatDate(shift['shift_date'] ?? '');

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'housing_shift'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          const SizedBox(height: 4),
          Text('shift_details'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),

          _buildCleanRow(
            icon: Icons.apartment,
            iconColor: AppColors.darkPurple,
            label: 'housing_unit'.tr,
            value: unitName,
          ),
          const Divider(height: 20, thickness: 1),

          _buildCleanRow(
            icon: Icons.meeting_room,
            iconColor: Colors.purple,
            label: 'room_number'.tr,
            value: roomNumber,
          ),
          const Divider(height: 20, thickness: 1),

          _buildCleanRow(
            icon: Icons.calendar_today,
            iconColor: Colors.teal,
            label: 'today_date'.tr,
            value: dateFormatted,
          ),

          const SizedBox(height: 24),

          Obx(() => _buildStatusSection(
                controller.isCheckedIn.value,
                controller.attendanceRecorded.value,
              )),
          const SizedBox(height: 24),

          Obx(() => _buildActionSection(
                context,
                shift,
                controller.isCheckedIn.value,
                controller.attendanceRecorded.value,
                controller.isCheckingIn.value,
                controller.isCancelling.value,
              )),
        ],
      ),
    );
  }

  Widget _buildCleanRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(bool isCheckedIn, bool isRecorded) {
    String statusText, statusMessage;
    Color statusColor;
    IconData statusIcon;

    if (isCheckedIn && isRecorded) {
      statusText = 'attendance_recorded'.tr;
      statusMessage = 'attendance_recorded_message'.tr;
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isCheckedIn && !isRecorded) {
      statusText = 'waiting_for_supervisor'.tr;
      statusMessage = 'waiting_for_supervisor_message'.tr;
      statusColor = Colors.orange;
      statusIcon = Icons.pending_actions;
    } else {
      statusText = 'not_recorded'.tr;
      statusMessage = 'not_recorded_message'.tr;
      statusColor = Colors.redAccent;
      statusIcon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
            child: Icon(statusIcon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: statusColor)),
                const SizedBox(height: 4),
                Text(statusMessage, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(
    BuildContext context,
    Map<String, dynamic> shift,
    bool isCheckedIn,
    bool isRecorded,
    bool isCheckingIn,
    bool isCancelling,
  ) {
    final shiftId = shift['id'] as int?;

    if (!isCheckedIn) {
      return GradientButton(
        text: "record_housing_attendance".tr,
        isLoading: isCheckingIn,
        onTap: () => _handleCheckIn(context, shift),
      );
    }

    // نفس مكان وشكل زر الإلغاء الموجود بالمحاضرات:
    // QR الكارت الأبيض بظل + زر outlined أحمر تحته لإلغاء الحضور،
    // بس لما يكون محسوب حضور ولسا ما انسجل من المشرف.
    if (isCheckedIn && !isRecorded) {
      return Column(
        children: [
          Text('your_qr_code'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: QrImageView(
              data: controller.qrToken.value,
              size: 220,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isCancelling ? null : () => _handleCancelCheckIn(context, shiftId!),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: isCancelling
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2))
                  : const Icon(Icons.cancel_outlined, size: 20),
              label: Text(
                isCancelling ? 'cancelling'.tr : 'cancel_check_in'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _handleCheckIn(BuildContext context, Map<String, dynamic> shift) {
    final shiftId = shift['id'] as int?;
    if (shiftId == null) {
      Get.snackbar('error'.tr, 'unable_to_identify_lecture'.tr, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    controller.checkIn(shiftId);
  }

  void _handleCancelCheckIn(BuildContext context, int shiftId) {
    Get.defaultDialog(
      title: 'confirm_cancel_title'.tr,
      titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      middleText: 'confirm_cancel_message'.tr,
      textConfirm: 'yes_cancel_attendance'.tr,
      textCancel: 'back'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey,
      onConfirm: () {
        Get.back();
        controller.cancelCheckIn(shiftId);
      },
    );
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      return date;
    }
  }
}