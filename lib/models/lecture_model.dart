class LectureModel {
  final int id;
  final String lectureName;
  final String status;
  final String date;

  LectureModel({
    required this.id,
    required this.lectureName,
    required this.status,
    required this.date,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'] ?? 0,
      lectureName: json['lecture_name'] ?? 'No Name',
      status: json['status'] ?? 'absent',
      date: json['created_at'] ?? '',
    );
  }
}