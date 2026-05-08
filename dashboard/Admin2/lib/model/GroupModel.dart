import 'SectionModel.dart';

class GroupModel {
  final int? id;
  final String groupNumber;
  final int sectionId;
  final int? studentsCount;
  final SectionModel? section; // بيانات الشعبة التابعة لها

  GroupModel({
    this.id,
    required this.groupNumber,
    required this.sectionId,
    this.studentsCount,
    this.section,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      groupNumber: json['group_number'],
      sectionId: json['section_id'] is String
          ? int.parse(json['section_id'])
          : json['section_id'],
      studentsCount: json['students_count'],
      section: json['section'] != null
          ? SectionModel.fromJson(json['section'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_number': groupNumber,
      'section_id': sectionId,
    };
  }
}