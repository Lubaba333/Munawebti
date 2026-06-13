// lib/models/EmergencyCase.dart
class EmergencyCase {
  final int id;
  final int? studentId;
  final int? supervisorId;
  final String title;
  final String description;
  final String severity;      // ✅ مهم: يجب أن يكون موجوداً
  final String status;
  final String createdAt;     // ✅ نستخدمه كـ String لتجنب مشاكل التاريخ
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? supervisor;

  EmergencyCase({
    required this.id,
    this.studentId,
    this.supervisorId,
    required this.title,
    required this.description,
    required this.severity,   // ✅ مطلوب
    required this.status,
    required this.createdAt,  // ✅ كـ String
    this.student,
    this.supervisor,
  });

  factory EmergencyCase.fromJson(Map<String, dynamic> json) {
  final severityValue = json['severity'] 
      ?? json['severity_level'] 
      ?? json['level'] 
      ?? 'medium';
      
  return EmergencyCase(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    severity: severityValue.toString().toLowerCase(), // ✅ توحيد الحالة
    status: json['status'] ?? 'pending',
    createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      student: json['student'] as Map<String, dynamic>?,
      supervisor: json['supervisor'] as Map<String, dynamic>?,
    );
  }

  // ✅ دالة مساعدة لتنسيق التاريخ للعرض
  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return createdAt; // إذا فشل التحليل نرجع النص الأصلي
    }
  }
}