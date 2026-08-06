class AttendanceHistoryModel {

  final int id;

  final int studentId;

  final int supervisorShiftId;

  final String shiftType;

  final String? checkInAt;

  final String? qrToken;

  final String? attendanceRecordedAt;

  final int? recordedBySupervisorId;


  final HistoryStudent? student;

  final HistoryShift? shift;



  AttendanceHistoryModel({

    required this.id,

    required this.studentId,

    required this.supervisorShiftId,

    required this.shiftType,

    this.checkInAt,

    this.qrToken,

    this.attendanceRecordedAt,

    this.recordedBySupervisorId,

    this.student,

    this.shift,

  });




  factory AttendanceHistoryModel.fromJson(
      Map<String,dynamic> json
      ){

    return AttendanceHistoryModel(


      id: json["id"] ?? 0,


      studentId:
      json["student_id"] ?? 0,


      supervisorShiftId:
      json["supervisor_shift_id"] ?? 0,


      shiftType:
      json["shift_type"] ?? "",



      checkInAt:
      json["check_in_at"],



      qrToken:
      json["qr_token"],



      attendanceRecordedAt:
      json["attendance_recorded_at"],



      recordedBySupervisorId:
      json["recorded_by_supervisor_id"],




      student:
      json["student"] != null

          ?

      HistoryStudent.fromJson(
          json["student"]
      )

          :

      null,




      shift:

      json["supervisor_shift"] != null

          ?

      HistoryShift.fromJson(
          json["supervisor_shift"]
      )

          :

      null,

    );


  }


}









class HistoryStudent {


  final int id;

  final String studentIdentifier;

  final String fullName;

  final String email;

  final String phoneNumber;

  final int? year;

  final String? specialization;

  final bool isResident;





  HistoryStudent({

    required this.id,

    required this.studentIdentifier,

    required this.fullName,

    required this.email,

    required this.phoneNumber,

    this.year,

    this.specialization,

    required this.isResident,

  });






  factory HistoryStudent.fromJson(
      Map<String,dynamic> json
      ){


    return HistoryStudent(


      id:
      json["id"] ?? 0,



      studentIdentifier:
      json["student_identifier"] ?? "",



      fullName:
      json["full_name"] ?? "",



      email:
      json["email"] ?? "",



      phoneNumber:
      json["phone_number"] ?? "",




      year:
      json["year"],




      specialization:
      json["specialization"],




      isResident:
      json["is_resident"] ?? false,



    );


  }


}









class HistoryShift {


  final int id;


  final int supervisorId;


  final String shiftType;


  final String shiftDate;


  final String day;


  final String fromHour;


  final String toHour;


  final String status;


  final String assignmentMethod;


  final String? notes;





  HistoryShift({


    required this.id,


    required this.supervisorId,


    required this.shiftType,


    required this.shiftDate,


    required this.day,


    required this.fromHour,


    required this.toHour,


    required this.status,


    required this.assignmentMethod,


    this.notes,


  });






  factory HistoryShift.fromJson(
      Map<String,dynamic> json
      ){



    return HistoryShift(


      id:
      json["id"] ?? 0,



      supervisorId:
      json["supervisor_id"] ?? 0,



      shiftType:
      json["shift_type"] ?? "",



      shiftDate:
      json["shift_date"] ?? "",




      day:
      json["day"] ?? "",




      fromHour:
      json["from_hour"] ?? "",




      toHour:
      json["to_hour"] ?? "",




      status:
      json["status"] ?? "",




      assignmentMethod:
      json["assignment_method"] ?? "",




      notes:
      json["notes"],



    );


  }


}