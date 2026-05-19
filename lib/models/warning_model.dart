class WarningModel {
  final int id;
  final String title;
  final String description;
  final String date;

  WarningModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      date: json['created_at'] ?? '',
    );
  }
}