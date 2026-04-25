class UserModel {
  final String name;
 // final String studentId; // ✅ أضفناه
  final String email;
  final String password;

  UserModel({
    required this.name,
   // required this.studentId, // ✅ مهم
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
     // 'student_id': studentId, // ✅ مهم جداً للباك إند
      'email': email,
      'password': password,
    };
  }
}