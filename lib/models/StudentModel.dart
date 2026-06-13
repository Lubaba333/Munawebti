class StudentModel {
  final int id;
  final String name;
  final String universityId;
  final String major;
  final String room;
  final String status;

  StudentModel({
    required this.id,
    required this.name,
    required this.universityId,
    required this.major,
    required this.room,
    required this.status,
  });


  factory StudentModel.fromJson(
      Map<String, dynamic> json) {

    return StudentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      universityId: json['university_id'] ?? '',
      major: json['major'] ?? '',
      room: json['room'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

