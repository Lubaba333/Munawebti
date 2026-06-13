class ReportModel {
  final int id;
  final int studentId;
  final String notes;
  final String createdAt;

  ReportModel({
    required this.id,
    required this.studentId,
    required this.notes,
    required this.createdAt,
  });

  factory ReportModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ReportModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      notes: json['notes'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}