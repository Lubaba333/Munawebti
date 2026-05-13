class DormitoryUnitModel {
  final int id;
  final String name;

  DormitoryUnitModel({required this.id, required this.name});

  factory DormitoryUnitModel.fromJson(Map<String, dynamic> json) {
    return DormitoryUnitModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}