class RequestModel {
  final int id;
  final String type;
  final String status;
  final String requesterType;
  final int requesterId;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  RequestModel({
    required this.id,
    required this.type,
    required this.status,
    required this.requesterType,
    required this.requesterId,
    required this.createdAt,
    this.metadata,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      type: json['request_type'] ?? '',
      status: json['status'] ?? 'pending',
      requesterType: json['requester_type'] ?? '',
      requesterId: json['requester_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      metadata: json['metadata'],
    );
  }
}