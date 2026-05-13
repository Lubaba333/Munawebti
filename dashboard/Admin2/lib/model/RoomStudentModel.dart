class RoomStudentModel {
  final int id;
  final String name;
  final String email;

  RoomStudentModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory RoomStudentModel.fromJson(Map<String, dynamic> json) {
    return RoomStudentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}