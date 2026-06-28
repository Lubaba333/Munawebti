class RequestModel {
  final int id;
  final String type;
  final String status;
  final String title;
  final String description;
  final Map<String, dynamic> metadata;

  final String? createdAt;
  final String? adminResponseReason;

  RequestModel({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.metadata,
    this.createdAt,
    this.adminResponseReason,
  });


  factory RequestModel.fromJson(Map<String, dynamic> json) {

    return RequestModel(

      id: json['id'] ?? 0,

      type: json['request_type'] ?? '',

      status: json['status'] ?? '',

      title: json['title'] ?? '',

      description: json['description'] ?? '',

      metadata:
      json['metadata'] ?? {},

      createdAt:
      json['created_at'],

      adminResponseReason:
      json['admin_response_reason'],
    );
  }
}