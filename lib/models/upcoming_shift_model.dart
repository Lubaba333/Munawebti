class ShiftModel {
  final int id;
  final String shiftType;
  final String shiftDate;
  final String? day;
  final String fromHour;
  final String toHour;
  final String? status;

  ShiftModel({
    required this.id,
    required this.shiftType,
    required this.shiftDate,
    this.day,
    required this.fromHour,
    required this.toHour,
    this.status,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'],
      shiftType: json['shift_type'],
      shiftDate: json['shift_date'],
      day: json['day'],
      fromHour: json['from_hour'],
      toHour: json['to_hour'],
      status: json['status'],
    );
  }
}

class CheckInSummaryModel {
  final int totalCheckedIn;
  final int attendanceRecorded;
  final int pendingScan;

  CheckInSummaryModel({
    required this.totalCheckedIn,
    required this.attendanceRecorded,
    required this.pendingScan,
  });

  factory CheckInSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckInSummaryModel(
      totalCheckedIn: json['total_checked_in'] ?? 0,
      attendanceRecorded: json['attendance_recorded'] ?? 0,
      pendingScan: json['pending_scan'] ?? 0,
    );
  }
}

class UpcomingShiftModel {
  final ShiftModel shift;
  final CheckInSummaryModel checkInSummary;

  UpcomingShiftModel({
    required this.shift,
    required this.checkInSummary,
  });

  factory UpcomingShiftModel.fromJson(Map<String, dynamic> json) {
    return UpcomingShiftModel(
      shift: ShiftModel.fromJson(json['shift']),
      checkInSummary: CheckInSummaryModel.fromJson(json['check_in_summary']),
    );
  }
}
