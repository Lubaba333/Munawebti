class RoomHistoryModel {
  final String action;
  final String studentName;
  final String date;

  RoomHistoryModel({
    required this.action,
    required this.studentName,
    required this.date,
  });

  factory RoomHistoryModel.fromJson(Map<String, dynamic> json) {
    return RoomHistoryModel(
      action: json['action'] ?? '',
      studentName: json['full_name'] ?? '', // 👈 مهم (مو student_name)
      date: json['created_at'] ?? '',
    );
  }
}