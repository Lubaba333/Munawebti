class StudentModel {
  final int id;
  final String studentIdentifier;
  final String fullName;
  final String email;
  final String specialization;
  final int year;

  StudentModel({
    required this.id,
    required this.studentIdentifier,
    required this.fullName,
    required this.email,
    required this.specialization,
    required this.year,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      // استخدام ?? 0 لضمان وجود قيمة دائماً ومنع الـ Null Error
      id: json['id'] ?? 0,
      studentIdentifier: json['student_identifier'] ?? "بدون رقم",
      fullName: json['full_name'] ?? "اسم غير معروف",
      email: json['email'] ?? "",
      specialization: json['specialization'] ?? "عام",

      // هذا السطر مهم جداً: يحول القيمة لرقم مهما كان نوعها من السيرفر
      year: json['year'] is int
          ? json['year']
          : int.tryParse(json['year'].toString()) ?? 0,
    );
  }
}