class LectureLocationModel {
  final int id;
  final int lectureId;
  final String labName;
  final List<GroupAssignment> groupAssignments;

  LectureLocationModel({
    required this.id,
    required this.lectureId,
    required this.labName,
    required this.groupAssignments,
  });

  factory LectureLocationModel.fromJson(Map<String, dynamic> json) {
    return LectureLocationModel(
      id: json['id'],
      lectureId: json['lecture_id'],
      labName: json['lab_name'] ?? "",
      groupAssignments: (json['group_assignments'] as List?)
          ?.map((e) => GroupAssignment.fromJson(e))
          .toList() ?? [],
    );
  }
}

class GroupAssignment {
  final int id;
  final int groupId;
  final GroupData group; // تأكد من وجود هذا السطر

  GroupAssignment({required this.id, required this.groupId, required this.group});

  factory GroupAssignment.fromJson(Map<String, dynamic> json) {
    return GroupAssignment(
      id: json['id'],
      groupId: json['group_id'],
      group: GroupData.fromJson(json['group']), // تحويل البيانات المتداخلة
    );
  }
}

class GroupData {
  final String groupNumber;
  final SectionData section;

  GroupData({required this.groupNumber, required this.section});

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      groupNumber: json['group_number'].toString(),
      section: SectionData.fromJson(json['section']),
    );
  }
}

class SectionData {
  final int year;
  final String sectionNumber;

  SectionData({required this.year, required this.sectionNumber});

  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      year: json['year'],
      sectionNumber: json['section_number'].toString(),
    );
  }
}