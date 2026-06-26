class SupervisorShiftsResponse {
  final List<ShiftDay> data;

  SupervisorShiftsResponse({
    required this.data,
  });

  factory SupervisorShiftsResponse.fromJson(Map<String, dynamic> json) {
    return SupervisorShiftsResponse(
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => ShiftDay.fromJson(e))
          .toList(),
    );
  }
}

class ShiftDay {
  final String date;
  final String day;
  final List<SupervisorShift> shifts;

  ShiftDay({
    required this.date,
    required this.day,
    required this.shifts,
  });

  factory ShiftDay.fromJson(Map<String, dynamic> json) {
    return ShiftDay(
      date: json["date"] ?? "",
      day: json["day"] ?? "",
      shifts: (json["shifts"] as List<dynamic>? ?? [])
          .map((e) => SupervisorShift.fromJson(e))
          .toList(),
    );
  }
}

class SupervisorShift {
  final int id;
  final int supervisorId;

  final String shiftType;
  final String shiftDate;
  final String day;

  final String startTime;
  final String endTime;

  final String status;

  final LectureAssignment? lectureAssignment;
  final HousingAssignment? housingAssignment;

  SupervisorShift({
    required this.id,
    required this.supervisorId,
    required this.shiftType,
    required this.shiftDate,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.lectureAssignment,
    this.housingAssignment,
  });

  factory SupervisorShift.fromJson(Map<String, dynamic> json) {
    return SupervisorShift(
      id: json["id"] ?? 0,
      supervisorId: json["supervisor_id"] ?? 0,
      shiftType: json["shift_type"] ?? "",
      shiftDate: json["shift_date"] ?? "",
      day: json["day"] ?? "",
      startTime: json["from_hour"] ?? "",
      endTime: json["to_hour"] ?? "",
      status: json["status"] ?? "",
      lectureAssignment: json["lecture_supervisor_assignment"] == null
          ? null
          : LectureAssignment.fromJson(
        json["lecture_supervisor_assignment"],
      ),
      housingAssignment: json["housing_supervisor_assignment"] == null
          ? null
          : HousingAssignment.fromJson(
        json["housing_supervisor_assignment"],
      ),
    );
  }
}

class LectureAssignment {
  final int id;

  final int lectureId;

  final String fromHour;
  final String toHour;

  final String subjectName;

  final String teacherName;

  final String labName;

  final String specialization;

  final String branch;

  final int year;

  final bool isPractical;

  LectureAssignment({
    required this.id,
    required this.lectureId,
    required this.fromHour,
    required this.toHour,
    required this.subjectName,
    required this.teacherName,
    required this.labName,
    required this.specialization,
    required this.branch,
    required this.year,
    required this.isPractical,
  });

  factory LectureAssignment.fromJson(Map<String, dynamic> json) {
    final lecture = json["lecture"] ?? {};

    final location = json["lecture_location_assignment"] ?? {};

    return LectureAssignment(
      id: json["id"] ?? 0,

      lectureId: json["lecture_id"] ?? 0,

      fromHour: json["from_hour"] ?? "",

      toHour: json["to_hour"] ?? "",

      subjectName: lecture["subject"]?["name"] ?? "",

      teacherName: lecture["teacher_name"] ?? "",

      labName: location["lab_name"] ?? "",

      specialization: lecture["specialization"] ?? "",

      branch: lecture["branch"] ?? "",

      year: lecture["year"] ?? 0,

      isPractical: lecture["is_practical"] ?? false,
    );
  }
}

class HousingAssignment {
  final int id;

  final String dormitoryName;

  final String fromHour;

  final String toHour;

  HousingAssignment({
    required this.id,
    required this.dormitoryName,
    required this.fromHour,
    required this.toHour,
  });

  factory HousingAssignment.fromJson(Map<String, dynamic> json) {
    return HousingAssignment(
      id: json["id"] ?? 0,

      dormitoryName:
      json["dormitory_unit"]?["name"] ?? "",

      fromHour: json["from_hour"] ?? "",

      toHour: json["to_hour"] ?? "",
    );
  }
}