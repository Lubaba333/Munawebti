class CurrentRoomModel {
  final String roomNumber;
  final String assignedAt;

  CurrentRoomModel({
    required this.roomNumber,
    required this.assignedAt,
  });

  factory CurrentRoomModel.fromJson(Map<String, dynamic> json) {
    return CurrentRoomModel(
      roomNumber: json['room_number'].toString(),
      assignedAt: json['assigned_at'] ?? '',
    );
  }
}