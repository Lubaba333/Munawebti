class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String? password;
  final String? phoneNumber;
  final String? studentIdentifier;
  final String? supervisorIdentifier;
  final String? specialization;
  final String? year;
  final String? annualAverage;
  final bool? isResident; // أضيف للطالبات
  final String? certificatePlace; // أضيف للمشرفات
  final String? certificateDate; // أضيف للمشرفات
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
    this.isResident,
    this.certificatePlace,
    this.certificateDate,
    required this.role,
    this.isBlocked = false,
  });

  /// ========================================================
  /// تحويل الكائن إلى JSON لإرساله للسيرفر (الإضافة والتعديل)
  /// ========================================================
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "full_name": fullName,
      "email": email,
      "specialization": specialization ?? "",
      "phone_number": phoneNumber ?? "+963900000000",
    };

    // إرسال كلمة المرور فقط عند الإضافة أو إذا تم تغييرها فعلياً
    if (password != null && password!.isNotEmpty) {
      data["password"] = password;
    }

    if (role == "Student") {
      data["student_identifier"] = studentIdentifier;
      data["year"] = int.tryParse(year.toString()) ?? 4; // تحويل لرقم
      data["is_resident"] = 1; // إرساله كـ Integer
      data["annual_average"] = double.tryParse(annualAverage.toString()) ?? 85.0; // تحويل لـ Double
    } else {
      data["supervisor_identifier"] = supervisorIdentifier;
      data["certificate_place"] = certificatePlace ?? "University X";
      data["certificate_date"] = certificateDate ?? "2020-05-15";
    }

    return data;
  }

  /// ========================================================
  /// استقبال البيانات من السيرفر وتحويلها لكائن Model
  /// ========================================================
  factory UserModel.fromJson(Map<String, dynamic> json, String role) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phone_number'],
      specialization: json['specialization'],
      // حقول الطالبة
      studentIdentifier: json['student_identifier'],
      year: json['year']?.toString(),
      annualAverage: json['annual_average']?.toString(),
      isResident: json['is_resident'] == 1 || json['is_resident'] == true,
      // حقول المشرفة
      supervisorIdentifier: json['supervisor_identifier'],
      certificatePlace: json['certificate_place'],
      certificateDate: json['certificate_date'],
      // الإعدادات العامة
      role: role,
      isBlocked: json['blocked_at'] != null, // إذا وجد تاريخ حظر فهو محظور
    );
  }
}