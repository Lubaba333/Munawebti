class RewardModel {
  final int id;
  final String title;
  final String description;
  final String createdAt;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory RewardModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RewardModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}