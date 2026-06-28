import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lecture_controller.dart';
import '../models/lecture_model.dart';
import '../utlis/app_colors.dart';

class LecturesView extends StatelessWidget {
  LecturesView({super.key});

  final LectureController controller = Get.put(LectureController());

  final List<String> days = const [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  final List<String> timeSlots = const [
    "08:30:00",
    "10:30:00",
    "12:30:00",
    "14:30:00",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    if (controller.lectures.isEmpty) {
                      return _emptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshLectures,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 22, 14, 24),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _weeklyTable(context),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
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
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Icon(
              Icons.table_chart_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "محاضراتي",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "جدول دوام المحاضرات الخاص بك",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.darkPurple.withOpacity(.14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPurple.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(135),
        border: TableBorder.all(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(22),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.softLavender,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            children: [
              _headerCell("اليوم / الوقت"),
              ...timeSlots.map((t) => _headerCell(_formatTime(t))),
            ],
          ),
          ...days.map((day) {
            return TableRow(
              children: [
                _dayCell(_arabicDay(day)),
                ...timeSlots.map((time) {
                  final lecture = _findLecture(day, time);
                  return _lectureCell(context, lecture);
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  LectureModel? _findLecture(String day, String time) {
    try {
      return controller.lectures.firstWhere(
        (lecture) => lecture.day == day && lecture.fromHour == time,
      );
    } catch (_) {
      return null;
    }
  }

  Widget _headerCell(String text) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.darkPurple,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dayCell(String day) {
    return Container(
      height: 82,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: AppColors.softLavender.withOpacity(.45),
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.darkPurple,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

 Widget _lectureCell(BuildContext context, LectureModel? lecture) {
  if (lecture == null) {
    return Container(
      height: 82,
      alignment: Alignment.center,
      child: Text(
        "—",
        style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 18,
        ),
      ),
    );
  }

  final color = lecture.isPractical
      ? Colors.orange
      : AppColors.darkPurple;

  return InkWell(
    onTap: () => _showLectureSheet(context, lecture),
    borderRadius: BorderRadius.circular(10),
    child: Container(
      height: 82,
      padding: const EdgeInsets.all(8),
      color: color.withOpacity(.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Text(
                    lecture.subjectName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: color.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.visibility_rounded,
                      size: 11,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Text(
            lecture.isPractical ? "عملي" : "نظري",
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

  void _showLectureSheet(BuildContext context, LectureModel lecture) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 18),
            Icon(
              lecture.isPractical
                  ? Icons.science_rounded
                  : Icons.menu_book_rounded,
              color: lecture.isPractical ? Colors.orange : AppColors.darkPurple,
              size: 45,
            ),
            const SizedBox(height: 10),
            Text(
              lecture.subjectName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            _sheetRow(Icons.person_rounded, "الدكتور", lecture.teacherName),
            _sheetRow(
              Icons.access_time_rounded,
              "الوقت",
              "${_formatTime(lecture.fromHour)} - ${_formatTime(lecture.toHour)}",
            ),
            _sheetRow(Icons.calendar_month_rounded, "اليوم", _arabicDay(lecture.day)),
            _sheetRow(Icons.location_on_rounded, "المكان", lecture.labName),
            _sheetRow(Icons.groups_rounded, "الفئة", lecture.groupNumber),
            _sheetRow(Icons.account_tree_rounded, "الشعبة", lecture.branch),
            _sheetRow(
              Icons.info_outline_rounded,
              "النوع",
              lecture.isPractical ? "عملي" : "نظري",
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _sheetRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.softLavender.withOpacity(.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkPurple, size: 20),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(
              color: AppColors.darkPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "غير محدد" : value,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }

  String _arabicDay(String day) {
    switch (day) {
      case "Sunday":
        return "الأحد";
      case "Monday":
        return "الاثنين";
      case "Tuesday":
        return "الثلاثاء";
      case "Wednesday":
        return "الأربعاء";
      case "Thursday":
        return "الخميس";
      case "Friday":
        return "الجمعة";
      case "Saturday":
        return "السبت";
      default:
        return day;
    }
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        "لا توجد محاضرات",
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}