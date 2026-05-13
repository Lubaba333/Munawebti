class RoomModel {
  final int id;
  final String roomNumber;
  final int capacity;
  final int dormitoryUnitId;

  RoomModel({
    required this.id,
    required this.roomNumber,
    required this.capacity,
    required this.dormitoryUnitId,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? 0,
      roomNumber: json['room_number'] ?? '',
      capacity: json['capacity'] ?? 0,
      dormitoryUnitId: json['dormitory_unit_id'] ?? 0,
    );
  }
}