class SectionModel {
  final int? id;
  final int year;
  final String academicYear;
  final String sectionNumber;

  SectionModel({
    this.id,
    required this.year,
    required this.academicYear,
    required this.sectionNumber,
  });

  // تحويل من JSON قادم من السيرفر إلى كائن في Dart
  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'],
      year: json['year'],
      academicYear: json['academic_year'] ?? "",
      sectionNumber: json['section_number'] ?? "",
    );
  }

  // تحويل الكائن إلى JSON لإرساله في طلبات Post/Put
  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'academic_year': academicYear,
      'section_number': sectionNumber,
    };
  }
}