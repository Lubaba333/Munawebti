class LectureAttendanceModel {
  final int id;
  final String status;
  final String attendanceDate;
  final String createdAt;

  final String subjectName;
  final String teacherName;
  final String day;
  final String fromHour;
  final String toHour;
  final String labName;
  final String groupNumber;
  final String branch;
  final String type;

  LectureAttendanceModel({
    required this.id,
    required this.status,
    required this.attendanceDate,
    required this.createdAt,
    required this.subjectName,
    required this.teacherName,
    required this.day,
    required this.fromHour,
    required this.toHour,
    required this.labName,
    required this.groupNumber,
    required this.branch,
    required this.type,
  });

  factory LectureAttendanceModel.fromJson(Map<String, dynamic> json) {
    final location = json['lecture_location'];
    final lecture = location is Map ? location['lecture'] : json['lecture'];
    final subject = lecture is Map ? lecture['subject'] : null;

    String lab = "غير محدد";
    if (location is Map) {
      lab = location['lab_name']?.toString() ??
          location['location']?.toString() ??
          "غير محدد";
    }

    String group = "غير محدد";
    final groups = location is Map ? location['groups'] : null;
    if (groups is List && groups.isNotEmpty) {
      final firstGroup = groups.first;
      if (firstGroup is Map) {
        group = firstGroup['group_number']?.toString() ??
            firstGroup['number']?.toString() ??
            "غير محدد";
      }
    }

    final isPractical = lecture is Map && lecture['is_practical'] == true;

    return LectureAttendanceModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? "غير محدد",
      attendanceDate: json['attendance_date']?.toString() ??
          json['date']?.toString() ??
          "غير محدد",
      createdAt: json['created_at']?.toString() ?? "غير محدد",
      subjectName: subject is Map
          ? subject['name']?.toString() ?? "غير محدد"
          : "غير محدد",
      teacherName: lecture is Map
          ? lecture['teacher_name']?.toString() ?? "غير محدد"
          : "غير محدد",
      day: lecture is Map ? lecture['day']?.toString() ?? "غير محدد" : "غير محدد",
      fromHour: lecture is Map
          ? lecture['from_hour']?.toString() ?? "غير محدد"
          : "غير محدد",
      toHour: lecture is Map
          ? lecture['to_hour']?.toString() ?? "غير محدد"
          : "غير محدد",
      labName: lab,
      groupNumber: group,
      branch: lecture is Map
          ? lecture['branch']?.toString() ?? "غير محدد"
          : "غير محدد",
      type: isPractical ? "عملي" : "نظري",
    );
  }
}