class ComplaintDetailModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String? adminResponse;

  ComplaintDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.adminResponse,
  });

  factory ComplaintDetailModel.fromJson(Map<String, dynamic> json) {
    return ComplaintDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      adminResponse: json['admin_response'], // 👈 مهم
    );
  }
}