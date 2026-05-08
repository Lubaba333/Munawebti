class SubjectModel {
  final int id;
  final String name;
  final bool hasPractical;
  final String? createdAt;

  SubjectModel({
    required this.id,
    required this.name,
    required this.hasPractical,
    this.createdAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      // التأكد من قراءة القيمة المنطقية بشكل صحيح
      hasPractical: json['has_practical'] == true || json['has_practical'] == 1,
      createdAt: json['created_at'],
    );
  }
}