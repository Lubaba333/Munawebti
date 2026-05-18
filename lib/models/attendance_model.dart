// lib/models/attendance_model.dart

class AttendanceRequest {
  final int lectureId;

  AttendanceRequest({required this.lectureId});

  Map<String, dynamic> toJson() {
    return {'lecture_id': lectureId};
  }
}

class AttendanceResponse {
  final bool success;
  final String message;
  final int? attendanceId;

  AttendanceResponse({
    required this.success,
    required this.message,
    this.attendanceId,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['status_code'] == 200 || json['status_code'] == 201,
      message: json['message'] ?? '',
      attendanceId: json['data']?['id'],
    );
  }
}