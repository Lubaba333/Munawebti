class StudentRoomHistoryModel {
  final String action;
  final String date;
  final String roomNumber;
  final String studentName;

  StudentRoomHistoryModel({
    required this.action,
    required this.date,
    required this.roomNumber,
    required this.studentName,
  });

  factory StudentRoomHistoryModel.fromJson(Map<String, dynamic> json) {
    return StudentRoomHistoryModel(
      action: json['action'] ?? '',
      date: json['created_at'] ?? '',
      roomNumber: json['room_number']?.toString() ?? '',
      studentName: json['full_name'] ?? '',
    );
  }
}