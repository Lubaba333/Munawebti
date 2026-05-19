class ViolationModel {
  final int id;
  final String title;
  final String description;
  final String date;

  ViolationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      date: json['created_at'] ?? '',
    );
  }
}