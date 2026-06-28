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
  final String createdAt;
  final String updatedAt;

  final String subjectName;
  final bool subjectHasPractical;

  final String groupNumber;
  final String labName;

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
    required this.createdAt,
    required this.updatedAt,
    required this.subjectName,
    required this.subjectHasPractical,
    required this.groupNumber,
    required this.labName,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'] ?? {};

    String groupNumber = "غير محدد";
    String labName = "غير محدد";

    final studentGroups = json['student_groups'];

    if (studentGroups is List && studentGroups.isNotEmpty) {
      final first = studentGroups.first;

      final group = first['group'];
      final location = first['location'];

      if (group is Map && group['group_number'] != null) {
        groupNumber = group['group_number'].toString();
      }

      if (location is Map) {
        labName = location['lab_name']?.toString() ??
            location['name']?.toString() ??
            "غير محدد";
      }
    }

    return LectureModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      year: int.tryParse(json['year'].toString()) ?? 0,
      specialization: json['specialization']?.toString() ?? "غير محدد",
      day: json['day']?.toString() ?? "غير محدد",
      branch: json['branch']?.toString() ?? "غير محدد",
      fromHour: json['from_hour']?.toString() ?? "غير محدد",
      toHour: json['to_hour']?.toString() ?? "غير محدد",
      subjectId: int.tryParse(json['subject_id'].toString()) ?? 0,
      isPractical: json['is_practical'] == true,
      teacherName: json['teacher_name']?.toString() ?? "غير محدد",
      createdAt: json['created_at']?.toString() ?? "غير محدد",
      updatedAt: json['updated_at']?.toString() ?? "غير محدد",
      subjectName: subject['name']?.toString() ?? "غير محدد",
      subjectHasPractical: subject['has_practical'] == true,
      groupNumber: groupNumber,
      labName: labName,
    );
  }
}