class MessageModel {
  final int id;
  final int conversationId;
  final String body;

  bool isMine;

  final String? readAt;
  final DateTime createdAt;

  final int senderId;
  final String senderType;
  final String senderName;
  final String senderEmail;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.body,
    required this.isMine,
    required this.readAt,
    required this.createdAt,
    required this.senderId,
    required this.senderType,
    required this.senderName,
    required this.senderEmail,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      conversationId: json["conversation_id"],
      body: json["body"] ?? "",
      isMine: json["is_mine"] ?? false,
      readAt: json["read_at"],
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
      senderId: json["sender"]["id"],
      senderType: json["sender"]["type"],
      senderName: json["sender"]["name"] ?? "",
      senderEmail: json["sender"]["email"] ?? "",
    );
  }
}