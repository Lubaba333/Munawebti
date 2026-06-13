class ViolationModel {

  final int id;
  final String title;
  final String description;
  final String violationDate;
  final String penalty;
  final String category;

  ViolationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.violationDate,
    required this.penalty,
    required this.category,
  });

  factory ViolationModel.fromJson(
      Map<String, dynamic> json) {

    return ViolationModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      violationDate:
      json['violation_date'] ?? '',
      penalty:
      json['penalty'] ?? '',
      category:
      json['category'] ?? '',
    );
  }
}