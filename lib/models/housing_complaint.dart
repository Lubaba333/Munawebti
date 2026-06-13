class HousingComplaint {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdAt;

  HousingComplaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory HousingComplaint.fromJson(Map<String, dynamic> json) {
    return HousingComplaint(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }
}