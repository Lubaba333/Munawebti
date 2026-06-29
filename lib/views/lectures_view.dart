import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lecture_controller.dart';
import '../models/lecture_model.dart';
import '../utlis/app_colors.dart';

class LecturesView extends StatelessWidget {
  final bool showBackButton;

  LecturesView({
    super.key,
    this.showBackButton = true,
  });

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
                      color: AppColors.mauve,
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
        if (showBackButton)
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

        if (showBackButton) const SizedBox(width: 12),

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
          color: AppColors.darkPurple.withOpacity(.18),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPurple.withOpacity(.10),
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
              color: AppColors.softLavender.withOpacity(.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            children: [
              _headerCell("اليوم / الوقت"),
              ...timeSlots.map((t) => _headerCell(_formatTime(t))),
            ],
          ),
          ...days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;

            return TableRow(
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.softLavender.withOpacity(.90),
              ),
              children: [
                _dayCell(_arabicDay(day), index),
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

  Widget _dayCell(String day, int index) {
    return Container(
      height: 82,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: index.isEven
          ? AppColors.softLavender.withOpacity(.45)
          : AppColors.softLavender.withOpacity(.62),
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

    final color = lecture.isPractical ? Colors.orange : AppColors.darkPurple;

    return InkWell(
      onTap: () => _showLectureSheet(context, lecture),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 82,
        padding: const EdgeInsets.all(8),
        color: color.withOpacity(.09),
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
                        color: color.withOpacity(.16),
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showLectureSheet(BuildContext context, LectureModel lecture) {
  final color = lecture.isPractical ? Colors.orange : AppColors.darkPurple;

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.mauve.withOpacity(.45),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Icon(
                  lecture.isPractical
                      ? Icons.science_rounded
                      : Icons.menu_book_rounded,
                  color: color,
                  size: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lecture.subjectName,
                    style: const TextStyle(
                      color: AppColors.darkPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _lectureDetailLine(
              icon: Icons.info_outline_rounded,
              title: "النوع",
              value: lecture.isPractical ? "عملي" : "نظري",
            ),
            _lectureDetailLine(
              icon: Icons.person_rounded,
              title: "الدكتور",
              value: lecture.teacherName,
            ),
            _lectureDetailLine(
              icon: Icons.access_time_rounded,
              title: "الوقت",
              value:
                  "${_formatTime(lecture.fromHour)} - ${_formatTime(lecture.toHour)}",
            ),
            _lectureDetailLine(
              icon: Icons.calendar_month_rounded,
              title: "اليوم",
              value: _arabicDay(lecture.day),
            ),
            _lectureDetailLine(
              icon: Icons.location_on_rounded,
              title: "المكان",
              value: lecture.labName,
            ),
            _lectureDetailLine(
              icon: Icons.groups_rounded,
              title: "الفئة",
              value: lecture.groupNumber,
            ),
            _lectureDetailLine(
              icon: Icons.account_tree_rounded,
              title: "الشعبة",
              value: lecture.branch,
              isLast: true,
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _lectureDetailLine({
  required IconData icon,
  required String title,
  required String value,
  bool isLast = false,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.darkPurple,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.darkPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value.isEmpty ? "غير محدد" : value,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (!isLast)
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
    ],
  );
}


Widget _miniInfoCard({
  required IconData icon,
  required String title,
  required String value,
  bool fullWidth = false,
}) {
  return Container(
    width: fullWidth ? double.infinity : null,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.softLavender.withOpacity(.65),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppColors.mauve.withOpacity(.22),
      ),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.darkPurple, size: 20),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? "غير محدد" : value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _sheetRow(IconData icon, String label, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.mauve.withOpacity(.16),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.darkPurple.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.darkPurple, size: 20),
        const SizedBox(width: 10),
        Text(
          "$label:",
          style: const TextStyle(
            color: AppColors.darkPurple,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? "غير محدد" : value,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

  String _formatTime(String time) {
    return time.length >= 5 ? time.substring(0, 5) : time;
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