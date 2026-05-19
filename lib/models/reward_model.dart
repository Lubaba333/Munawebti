class RewardModel {
  final int id;
  final String title;
  final String description;
  final String date;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Reward',
      description: json['description'] ?? '',
      date: json['created_at'] ?? '',
    );
  }
}