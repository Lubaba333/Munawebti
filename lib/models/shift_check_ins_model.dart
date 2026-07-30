class ShiftBasicModel {
  final int id;
  final String shiftType;
  final String shiftDate;
  final String fromHour;
  final String toHour;

  ShiftBasicModel({
    required this.id,
    required this.shiftType,
    required this.shiftDate,
    required this.fromHour,
    required this.toHour,
  });

  factory ShiftBasicModel.fromJson(Map<String, dynamic> json) {
    return ShiftBasicModel(
      id: json['id'],
      shiftType: json['shift_type'],
      shiftDate: json['shift_date'],
      fromHour: json['from_hour'],
      toHour: json['to_hour'],
    );
  }
}

class StudentModel {
  final int id;
  final String studentIdentifier;
  final String fullName;

  StudentModel({
    required this.id,
    required this.studentIdentifier,
    required this.fullName,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      studentIdentifier: json['student_identifier'],
      fullName: json['full_name'],
    );
  }
}

class StudentCheckInModel {
  final int checkInId;
  final StudentModel student;
  final String checkInAt;
  final bool attendanceRecorded;
  final String? attendanceRecordedAt;

  StudentCheckInModel({
    required this.checkInId,
    required this.student,
    required this.checkInAt,
    required this.attendanceRecorded,
    this.attendanceRecordedAt,
  });

  factory StudentCheckInModel.fromJson(Map<String, dynamic> json) {
    return StudentCheckInModel(
      checkInId: json['check_in_id'],
      student: StudentModel.fromJson(json['student']),
      checkInAt: json['check_in_at'],
      attendanceRecorded: json['attendance_recorded'] ?? false,
      attendanceRecordedAt: json['attendance_recorded_at'],
    );
  }
}

class CheckInsSummaryModel {
  final int totalCheckedIn;
  final int attendanceRecorded;

  CheckInsSummaryModel({
    required this.totalCheckedIn,
    required this.attendanceRecorded,
  });

  factory CheckInsSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckInsSummaryModel(
      totalCheckedIn: json['total_checked_in'] ?? 0,
      attendanceRecorded: json['attendance_recorded'] ?? 0,
    );
  }
}

class ShiftCheckInsModel {
  final ShiftBasicModel shift;
  final List<StudentCheckInModel> students;
  final CheckInsSummaryModel summary;

  ShiftCheckInsModel({
    required this.shift,
    required this.students,
    required this.summary,
  });

  factory ShiftCheckInsModel.fromJson(Map<String, dynamic> json) {
    return ShiftCheckInsModel(
      shift: ShiftBasicModel.fromJson(json['shift']),
      students: (json['students'] as List)
          .map((e) => StudentCheckInModel.fromJson(e))
          .toList(),
      summary: CheckInsSummaryModel.fromJson(json['summary']),
    );
  }
}
