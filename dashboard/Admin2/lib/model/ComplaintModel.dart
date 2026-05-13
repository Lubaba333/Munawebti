class ComplaintModel {
  final int id;
  final String title;
  final String status;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.status,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      title: json['title'] ?? '',
      status: json['status'] ?? '',
    );
  }
}