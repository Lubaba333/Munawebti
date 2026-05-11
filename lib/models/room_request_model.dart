class RoomRequestModel {
  String type;
  String reason;
  int? targetRoomId;
  int? swapStudentId;

  RoomRequestModel({
    required this.type,
    required this.reason,
    this.targetRoomId,
    this.swapStudentId,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "reason": reason,
      "target_room_id": targetRoomId,
      "swap_student_id": swapStudentId,
    };
  }
}