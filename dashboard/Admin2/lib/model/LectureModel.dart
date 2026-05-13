import 'SubjectModel.dart';

class LectureModel {
  final int id;
  final int year;
  final String specialization;
  final String day;
  final String branch;
  final String fromHour;
  final String toHour;
  final int subjectId;
  final bool isPractical;
  final String teacherName;
  final SubjectModel? subject;

  LectureModel({
    required this.id,
    required this.year,
    required this.specialization,
    required this.day,
    required this.branch,
    required this.fromHour,
    required this.toHour,
    required this.subjectId,
    required this.isPractical,
    required this.teacherName,
    this.subject,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'] ?? 0,
      year: json['year'] is int ? json['year'] : int.tryParse(json['year'].toString()) ?? 0,
      specialization: json['specialization'] ?? "",
      day: json['day'] ?? "",
      branch: json['branch'] ?? "",
      fromHour: json['from_hour'] ?? "",
      toHour: json['to_hour'] ?? "",
      subjectId: json['subject_id'] is int ? json['subject_id'] : int.tryParse(json['subject_id'].toString()) ?? 0,
      isPractical: json['is_practical'] == true || json['is_practical'] == 1,
      teacherName: json['teacher_name'] ?? "",
      subject: json['subject'] != null ? SubjectModel.fromJson(json['subject']) : null,
    );
  }
}