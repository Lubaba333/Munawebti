class ConversationModel {

  final int id;

  final int otherUserId;
  final String otherUserType;
  final String otherUserName;
  final String otherUserEmail;

  String lastMessage;

  int unreadCount;

  DateTime? lastMessageAt;

  ConversationModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserType,
    required this.otherUserName,
    required this.otherUserEmail,
    required this.lastMessage,
    required this.unreadCount,
    required this.lastMessageAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {

    return ConversationModel(
      id: json["id"],

      otherUserId: json["other_user"]["id"],

      otherUserType: json["other_user"]["type"] ?? "",

      otherUserName: json["other_user"]["name"] ?? "",

      otherUserEmail: json["other_user"]["email"] ?? "",

      lastMessage: json["last_message"]?["text"] ?? "",

      unreadCount: json["unread_count"] ?? 0,

      lastMessageAt: json["last_message_at"] == null
          ? null
          : DateTime.parse(json["last_message_at"]).toLocal(),
    );
  }
}