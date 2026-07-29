import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:studants/controllers/lecture_attendance_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/views/attendance_history_view.dart';
import 'package:studants/widgets/gradient_button.dart';

class LectureAttendanceView extends StatelessWidget {
  LectureAttendanceView({super.key});

  final controller = Get.put(LectureAttendanceController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUpcomingLecture();
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
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.mauve));
                    }
                    if (controller.errorMessage.value.isNotEmpty) return _errorState(context);
                    if (!controller.hasUpcomingLecture) return _emptyState(context);
                    
                    return _buildCleanContent(context, controller.upcomingLecture.value!);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(color: Colors.white.withOpacity(.20), borderRadius: BorderRadius.circular(14)),
            child: IconButton(
              onPressed: () { controller.stopQrTimer(); Get.back(); },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
          const SizedBox(width: 14),
          const Expanded(
            child: Text("المحاضرة القادمة", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
            Text(controller.errorMessage.value, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14)),
            const SizedBox(height: 24),
            GradientButton(text: "إعادة المحاولة", onTap: controller.getUpcomingLecture),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 60, color: Get.isDarkMode ? AppColors.mauve : AppColors.darkPurple),
          const SizedBox(height: 16),
          Text("لا توجد محاضرات قادمة", style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCleanContent(BuildContext context, Map<String, dynamic> lecture) {
   String title = lecture['subject_name'] ?? 'عنوان المحاضرة';
    String dayArabic = _translateDay(lecture['day'] ?? '');
    String timeFormatted = _formatTime(lecture['from_hour'] ?? '', lecture['to_hour'] ?? '');
    String dateFormatted = _formatDate(lecture['shift_date'] ?? '');
    String location = lecture['location'] ?? 'غير محدد';
    String teacher = lecture['teacher_name'] ?? 'غير محدد';
    
  

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
          const SizedBox(height: 4),
          const Text('تفاصيل المحاضرة', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),

          _buildCleanRow(icon: Icons.access_time, iconColor: AppColors.darkPurple, label: 'الوقت', value: timeFormatted),
          const Divider(height: 20, thickness: 1),
          _buildCleanRow(icon: Icons.calendar_today, iconColor: Colors.purple, label: 'التاريخ', value: '$dateFormatted - $dayArabic'),
          const Divider(height: 20, thickness: 1),
          _buildCleanRow(icon: Icons.location_on, iconColor: Colors.blue, label: 'المكان', value: location),
          const Divider(height: 20, thickness: 1),
          _buildCleanRow(icon: Icons.person_outline, iconColor: Colors.teal, label: 'المدرس', value: teacher),
          
      
          
          const SizedBox(height: 24),

          Obx(() => _buildStatusSection(
            controller.isCheckedIn.value,
            controller.attendanceRecorded.value,
            controller.isQrExpired.value,
          )),
          const SizedBox(height: 24),

          Obx(() => _buildActionSection(
            context,
            lecture,
            controller.isCheckedIn.value,
            controller.attendanceRecorded.value,
            controller.isCheckingIn.value,
            controller.isCancelling.value,
            controller.isQrExpired.value,
            controller.qrCreatedAt.value,
          )),
          const SizedBox(height: 20),

          GradientButton(
            text: "📜 سجلات الحضور",
            onTap: () => Get.to(() => const AttendanceHistoryView()),
          ),
        ],
      ),
    );
  }

  // 🔥 التعديل هنا لمنع قص النصوص الطويلة
  Widget _buildCleanRow({required IconData icon, required Color iconColor, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // يمنع قص النص ويجعله ينزل لسطر جديد
      children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
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
                softWrap: true, // السماح للنص بالالتفاف
                overflow: TextOverflow.visible, // منع ظهور "..."
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(bool isCheckedIn, bool isRecorded, bool isExpired) {
    String statusText, statusMessage;
    Color statusColor;
    IconData statusIcon;

    if (isCheckedIn && isRecorded) {
      statusText = 'تم تسجيل الحضور'; statusMessage = 'تم اعتماد حضورك في النظام بنجاح'; statusColor = Colors.green; statusIcon = Icons.check_circle;
    } else if (isCheckedIn && !isRecorded && !isExpired) {
      statusText = 'بانتظار مسح المشرفة'; statusMessage = 'اعرضي رمز QR للمشرفة، أو ألغي التسجيل'; statusColor = Colors.orange; statusIcon = Icons.pending_actions;
    } else if (isCheckedIn && !isRecorded && isExpired) {
      statusText = 'انتهت صلاحية الرمز'; statusMessage = 'الرمز منتهي الصلاحية، يرجى التواصل مع المشرفة'; statusColor = Colors.red; statusIcon = Icons.timer_off;
    } else {
      statusText = 'لم يتم تسجيل الحضور'; statusMessage = 'اضغطي على زر "تسجيل الحضور" أدناه'; statusColor = Colors.redAccent; statusIcon = Icons.cancel_outlined;
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
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle), child: Icon(statusIcon, color: Colors.white, size: 20)),
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
    BuildContext context, Map<String, dynamic> lecture, bool isCheckedIn, bool isRecorded, bool isCheckingIn, bool isCancelling, bool isExpired, DateTime? qrCreatedAt,
  ) {
    final shiftId = lecture['id'] as int?;

    if (!isCheckedIn) {
      return GradientButton(
        text: "📱 تسجيل الحضور",
        isLoading: isCheckingIn,
        onTap: () => _handleCheckIn(context, lecture),
      );
    }

    if (isCheckedIn && !isRecorded && !isExpired) {
      return Column(
        children: [
          const Text('رمز QR الخاص بك', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: QrImageView(
              data: Get.find<LectureAttendanceController>().qrToken.value,
              size: 220,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(height: 16),
          _buildRemainingTimeWidget(qrCreatedAt),
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
              icon: isCancelling ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2)) : const Icon(Icons.cancel_outlined, size: 20),
              label: Text(isCancelling ? 'جاري الإلغاء...' : 'إلغاء تسجيل الحضور', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }

    if (isCheckedIn && !isRecorded && isExpired) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.red, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('انتهت صلاحية الرمز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  SizedBox(height: 4),
                  Text('الرمز منتهي الصلاحية، يرجى التواصل مع المشرفة', style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تم تسجيل الحضور بنجاح!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 4),
                Text('بالتوفيق في محاضرتك 🎓', style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTimeWidget(DateTime? qrCreatedAt) {
    if (qrCreatedAt == null) return const SizedBox.shrink();
    final elapsed = DateTime.now().difference(qrCreatedAt);
    final remaining = const Duration(hours: 3) - elapsed;
    if (remaining.isNegative) return const SizedBox.shrink();

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.blue, size: 18),
          const SizedBox(width: 8),
          Text(
            'الوقت المتبقي: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _handleCheckIn(BuildContext context, Map<String, dynamic> lecture) {
    final shiftId = lecture['id'] as int?;
    if (shiftId == null) {
      Get.snackbar('❌ خطأ', 'لا يمكن تحديد المحاضرة', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.defaultDialog(
      title: 'تأكيد الحضور',
      middleText: 'هل أنت متأكدة من رغبتك في تسجيل الحضور لهذه المحاضرة؟',
      textConfirm: 'نعم، سجل حضور',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.darkPurple,
      cancelTextColor: AppColors.darkPurple,
      onConfirm: () {
        Get.back();
        Get.find<LectureAttendanceController>().checkIn(shiftId);
      },
    );
  }

  void _handleCancelCheckIn(BuildContext context, int shiftId) {
    Get.defaultDialog(
      title: 'تأكيد الإلغاء',
      titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      middleText: 'هل أنت متأكدة من إلغاء تسجيل الحضور؟\nلا يمكن التراجع عن هذا الإجراء.',
      textConfirm: 'نعم، إلغاء الحضور',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey,
      onConfirm: () {
        Get.back();
        Get.find<LectureAttendanceController>().cancelCheckIn(shiftId);
      },
    );
  }

  String _translateDay(String day) {
    switch (day) {
      case 'Sunday': return 'الأحد';
      case 'Monday': return 'الإثنين';
      case 'Tuesday': return 'الثلاثاء';
      case 'Wednesday': return 'الأربعاء';
      case 'Thursday': return 'الخميس';
      case 'Friday': return 'الجمعة';
      case 'Saturday': return 'السبت';
      default: return day;
    }
  }

  String _formatTime(String from, String to) {
    try {
      final fromTime = DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(from));
      final toTime = DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(to));
      return '$fromTime - $toTime';
    } catch (_) {
      return '$from - $to';
    }
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