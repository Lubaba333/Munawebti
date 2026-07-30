class AttendanceScanResponse {
  final bool success;
  final String message;
  final ScanStudent student;
  final ScanShift shift;
  final String attendanceRecordedAt;

  AttendanceScanResponse({
    required this.success,
    required this.message,
    required this.student,
    required this.shift,
    required this.attendanceRecordedAt,
  });

  factory AttendanceScanResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AttendanceScanResponse(
      success: data['success'],
      message: data['message'],
      student: ScanStudent.fromJson(data['student']),
      shift: ScanShift.fromJson(data['shift']),
      attendanceRecordedAt: data['attendance_recorded_at'],
    );
  }
}

class ScanStudent {
  final int id;
  final String studentIdentifier;
  final String fullName;

  ScanStudent({
    required this.id,
    required this.studentIdentifier,
    required this.fullName,
  });

  factory ScanStudent.fromJson(Map<String, dynamic> json) {
    return ScanStudent(
      id: json['id'],
      studentIdentifier: json['student_identifier'],
      fullName: json['full_name'],
    );
  }
}

class ScanShift {
  final int id;
  final String shiftType;
  final String shiftDate;

  ScanShift({
    required this.id,
    required this.shiftType,
    required this.shiftDate,
  });

  factory ScanShift.fromJson(Map<String, dynamic> json) {
    return ScanShift(
      id: json['id'],
      shiftType: json['shift_type'],
      shiftDate: json['shift_date'],
    );
  }
}