class DormitoryAttendance {
  final int id;
  final String status;
  final String createdAt;

  DormitoryAttendance({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory DormitoryAttendance.fromJson(Map<String, dynamic> json) {
    return DormitoryAttendance(
      id: json['id'],
      status: json['status'] ?? 'unknown',
      createdAt: json['created_at'] ?? '',
    );
  }
}