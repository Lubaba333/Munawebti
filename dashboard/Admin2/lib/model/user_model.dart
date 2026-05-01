class UserModel {
  final int? id; // جعلناه nullable لأنه لا يوجد id عند الإضافة الجديدة
  final String fullName;
  final String email;
  final String? password; // حقل اختياري للتعديل، إلزامي للإضافة
  final String? phoneNumber;
  final String? studentIdentifier;
  final String? supervisorIdentifier; // أضيفي هذا للمشرفات
  final String? specialization;
  final String? year; // للطالبات
  final String? annualAverage; // للطالبات
  final String role;
  final bool isBlocked;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.password,
    this.phoneNumber,
    this.studentIdentifier,
    this.supervisorIdentifier,
    this.specialization,
    this.year,
    this.annualAverage,
    required this.role,
    this.isBlocked = false,
  });

  // دالة تحويل الكائن إلى JSON للإرسال إلى السيرفر[cite: 4]
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'full_name': fullName,
      'email': email,
      if (password != null) 'password': password,
      'specialization': specialization,
    };

    if (role == "Student") {
      data.addAll({
        'student_identifier': studentIdentifier,
        'phone_number': phoneNumber,
        'year': year,
        'annual_average': annualAverage,
      });
    } else {
      data.addAll({
        'supervisor_identifier': supervisorIdentifier,
        // أضيفي حقول الشهادة هنا إذا كانت مطلوبة في الواجهة
      });
    }
    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String role) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phone_number'],
      studentIdentifier: json['student_identifier'],
      supervisorIdentifier: json['supervisor_identifier'],
      specialization: json['specialization'],
      year: json['year']?.toString(),
      annualAverage: json['annual_average']?.toString(),
      role: role,
      isBlocked: json['blocked_at'] != null,
    );
  }
}