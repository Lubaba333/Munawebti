// class StudentModel {
//   final int id;
//   final String name;
//   final String universityId;
//   final String major;
//   final String room;
//   final String status;
//
//   StudentModel({
//     required this.id,
//     required this.name,
//     required this.universityId,
//     required this.major,
//     required this.room,
//     required this.status,
//   });
//
//
//   factory StudentModel.fromJson(
//       Map<String, dynamic> json) {
//
//     return StudentModel(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       universityId: json['university_id'] ?? '',
//       major: json['major'] ?? '',
//       room: json['room'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }
//



class StudentModel {
  final int id;
  final String fullName;
  final String studentIdentifier;
  final String email;
  final String phoneNumber;
  final int year;
  final String specialization;
  final bool isResident;
  final String? annualAverage;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.studentIdentifier,
    required this.email,
    required this.phoneNumber,
    required this.year,
    required this.specialization,
    required this.isResident,
    this.annualAverage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      studentIdentifier: json['student_identifier'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      year: json['year'] ?? 0,
      specialization: json['specialization'] ?? '',
      isResident: json['is_resident'] ?? false,
      annualAverage: json['annual_average']?.toString(),
    );
  }
}