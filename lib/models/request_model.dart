// lib/models/request_model.dart

/// مودل طلب إذن خروج
class ExitPermissionRequest {
  final String title;
  final String description;
  final String exitDate;
  final String fromHour;
  final String toHour;
  final String reason;

  ExitPermissionRequest({
    required this.title,
    required this.description,
    required this.exitDate,
    required this.fromHour,
    required this.toHour,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_type': 'student_exit_permission',
      'title': title,  // ✅ تأكد من إرسال title
      'description': description,
      'metadata': {
        'exit_date': exitDate,
        'from_hour': fromHour,
        'to_hour': toHour,
        'reason': reason,
      },
    };
  }
}

/// مودل طلب تغيير غرفة
class RoomChangeRequest {
  final String title;
  final String description;
  final int currentRoomId;
  final int requestedRoomId;
  final String reason;

  RoomChangeRequest({
    required this.title,
    required this.description,
    required this.currentRoomId,
    required this.requestedRoomId,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_type': 'student_room_change',
      'title': title,  // ✅ تأكد من إرسال title
      'description': description,
      'metadata': {
        'current_room_id': currentRoomId,
        'requested_room_id': requestedRoomId,
        'reason': reason,
      },
    };
  }
}