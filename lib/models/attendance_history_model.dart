class AttendanceHistoryModel {
  final int id;
  final String shiftType;
  final String checkInAt;
  final String attendanceRecordedAt;
  final HistoryStudent student;
  final HistoryShift shift;

  AttendanceHistoryModel({
    required this.id,
    required this.shiftType,
    required this.checkInAt,
    required this.attendanceRecordedAt,
    required this.student,
    required this.shift,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      id: json["id"],
      shiftType: json["shift_type"],
      checkInAt: json["check_in_at"],
      attendanceRecordedAt: json["attendance_recorded_at"],
      student: HistoryStudent.fromJson(json["student"]),
      shift: HistoryShift.fromJson(json["supervisor_shift"]),
    );
  }
}

class HistoryStudent {
  final int id;
  final String studentIdentifier;
  final String fullName;

  HistoryStudent({
    required this.id,
    required this.studentIdentifier,
    required this.fullName,
  });

  factory HistoryStudent.fromJson(Map<String, dynamic> json) {
    return HistoryStudent(
      id: json["id"],
      studentIdentifier: json["student_identifier"],
      fullName: json["full_name"],
    );
  }
}

class HistoryShift {
  final int id;
  final String shiftDate;
  final String fromHour;
  final String toHour;

  HistoryShift({
    required this.id,
    required this.shiftDate,
    required this.fromHour,
    required this.toHour,
  });

  factory HistoryShift.fromJson(Map<String, dynamic> json) {
    return HistoryShift(
      id: json["id"],
      shiftDate: json["shift_date"],
      fromHour: json["from_hour"],
      toHour: json["to_hour"],
    );
  }
}