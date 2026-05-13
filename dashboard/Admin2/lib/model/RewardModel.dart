class RewardModel {
  final int id;
  final String targetType;
  final int targetId;
  final String rewardType;
  final String title;
  final String description;
  final String rewardDate;
  final int points;

  RewardModel({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.rewardType,
    required this.title,
    required this.description,
    required this.rewardDate,
    required this.points,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] ?? 0,
      targetType: json['target_type'] ?? '',
      targetId: json['target_id'] ?? 0,
      rewardType: json['reward_type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rewardDate: json['reward_date'] ?? '',
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "target_type": targetType,
      "target_id": targetId,
      "reward_type": rewardType,
      "title": title,
      "description": description,
      "reward_date": rewardDate,
      "points": points,
    };
  }
}