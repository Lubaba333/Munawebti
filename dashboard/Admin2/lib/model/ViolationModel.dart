class ViolationModel {
  final int id;
  final String title;
  final String description;
  final String violationDate;
  final String category;
  final String penalty;
  final String targetType;
  final int targetId;

  ViolationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.violationDate,
    required this.category,
    required this.penalty,
    required this.targetType,
    required this.targetId,
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      violationDate: json['violation_date'] ?? '',
      category: json['category'] ?? '',
      penalty: json['penalty'] ?? '',
      targetType: json['target_type'] ?? '',
      targetId: json['target_id'] ?? 0,
    );
  }
}