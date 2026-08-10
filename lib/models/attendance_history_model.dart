
class AttendanceHistoryModel {
final int id;
final HistoryStudent student;
final String shiftType;
final String? checkInAt;
final String? attendanceRecordedAt;
final String status;
final HistoryShift shift;
final HistoryShiftDetails shiftDetails;

AttendanceHistoryModel({
required this.id,
required this.student,
required this.shiftType,
this.checkInAt,
this.attendanceRecordedAt,
required this.status,
required this.shift,
required this.shiftDetails,
});

factory AttendanceHistoryModel.fromJson(
Map<String, dynamic> json,
) {
return AttendanceHistoryModel(
id: json['id'] ?? 0,

student: HistoryStudent.fromJson(
json['student'] ?? {},
),

shiftType: json['shift_type'] ?? '',

checkInAt: json['check_in_at'],

attendanceRecordedAt:
json['attendance_recorded_at'],

status: json['status'] ?? '',

shift: HistoryShift.fromJson(
json['shift'] ?? {},
),

shiftDetails: HistoryShiftDetails.fromJson(
json['shift_details'] ?? {},
),
);
}

/// هل الطالب حاضر؟
bool get isPresent => status == 'present';

/// هل الطالب غائب؟
bool get isAbsent => status == 'absent';

/// حالة الحضور بالعربي
String get statusText {
switch (status) {
case 'present':
return 'حاضر';

case 'absent':
return 'غائب';

default:
return status;
}
}

/// نوع السجل بالعربي
String get shiftTypeText {
switch (shiftType) {
case 'lecture':
return 'محاضرة';

case 'housing':
return 'سكن';

default:
return shiftType;
}
}
}


// ======================================================
// STUDENT
// ======================================================

class HistoryStudent {
final int id;
final String studentIdentifier;
final String fullName;

HistoryStudent({
required this.id,
required this.studentIdentifier,
required this.fullName,
});

factory HistoryStudent.fromJson(
Map<String, dynamic> json,
) {
return HistoryStudent(
id: json['id'] ?? 0,

studentIdentifier:
json['student_identifier'] ?? '',

fullName:
json['full_name'] ?? '',
);
}
}


// ======================================================
// SHIFT
// ======================================================

class HistoryShift {
final int id;
final String shiftType;
final String shiftDate;
final String day;
final String fromHour;
final String toHour;

HistoryShift({
required this.id,
required this.shiftType,
required this.shiftDate,
required this.day,
required this.fromHour,
required this.toHour,
});

factory HistoryShift.fromJson(
Map<String, dynamic> json,
) {
return HistoryShift(
id: json['id'] ?? 0,

shiftType:
json['shift_type'] ?? '',

shiftDate:
json['shift_date'] ?? '',

day:
json['day'] ?? '',

fromHour:
json['from_hour'] ?? '',

toHour:
json['to_hour'] ?? '',
);
}
}


// ======================================================
// SHIFT DETAILS
// ======================================================

class HistoryShiftDetails {
// Lecture
final String? subjectName;
final String? teacherName;
final String? location;
final bool? isPractical;
final int? year;
final String? specialization;
final String? branch;

// Housing
final String? dormitoryName;
final HistoryRoom? room;

HistoryShiftDetails({
this.subjectName,
this.teacherName,
this.location,
this.isPractical,
this.year,
this.specialization,
this.branch,
this.dormitoryName,
this.room,
});

factory HistoryShiftDetails.fromJson(
Map<String, dynamic> json,
) {
return HistoryShiftDetails(
subjectName:
json['subject_name'],

teacherName:
json['teacher_name'],

location:
json['location'],

isPractical:
json['is_practical'],

year:
json['year'],

specialization:
json['specialization'],

branch:
json['branch'],

dormitoryName:
json['dormitory_name'],

room: json['room'] != null
? HistoryRoom.fromJson(
json['room'],
)
    : null,
);

}

/// هل تفاصيل السجل لمحاضرة؟
bool get isLecture =>
subjectName != null;

/// هل تفاصيل السجل للسكن؟
bool get isHousing =>
dormitoryName != null;
}


// ======================================================
// ROOM
// ======================================================

class HistoryRoom {
final int id;
final String roomNumber;

HistoryRoom({
required this.id,
required this.roomNumber,
});

factory HistoryRoom.fromJson(
Map<String, dynamic> json,
) {
return HistoryRoom(
id: json['id'] ?? 0,

roomNumber:
json['room_number'] ?? '',
);
}
}

