class EmergencyCase {

  final int id;

  final int studentId;

  final int supervisorId;

  final String title;

  final String description;

  final String status;

  final String createdAt;

  final String updatedAt;


  final Student student;

  final Supervisor supervisor;



  EmergencyCase({

    required this.id,

    required this.studentId,

    required this.supervisorId,

    required this.title,

    required this.description,

    required this.status,

    required this.createdAt,

    required this.updatedAt,

    required this.student,

    required this.supervisor,

  });



  factory EmergencyCase.fromJson(Map<String,dynamic> json){


    return EmergencyCase(


      id: json['id'] ?? 0,


      studentId:
      json['student_id'] ?? 0,


      supervisorId:
      json['supervisor_id'] ?? 0,



      title:
      json['title'] ?? '',



      description:
      json['description'] ?? '',



      status:
      json['status'] ?? '',



      createdAt:
      json['created_at'] ?? '',



      updatedAt:
      json['updated_at'] ?? '',



      student:
      Student.fromJson(
        json['student'] ?? {},
      ),



      supervisor:
      Supervisor.fromJson(
        json['supervisor'] ?? {},
      ),


    );

  }

}





class Student {


  final int id;

  final String studentIdentifier;

  final String fullName;

  final String email;

  final String phoneNumber;

  final int year;

  final String specialization;

  final bool isResident;

  final String annualAverage;



  Student({

    required this.id,

    required this.studentIdentifier,

    required this.fullName,

    required this.email,

    required this.phoneNumber,

    required this.year,

    required this.specialization,

    required this.isResident,

    required this.annualAverage,

  });



  factory Student.fromJson(Map<String,dynamic> json){


    return Student(


      id:
      json['id'] ?? 0,



      studentIdentifier:
      json['student_identifier'] ?? '',



      fullName:
      json['full_name'] ?? '',



      email:
      json['email'] ?? '',



      phoneNumber:
      json['phone_number'] ?? '',



      year:
      json['year'] ?? 0,



      specialization:
      json['specialization'] ?? '',



      isResident:
      json['is_resident'] ?? false,



      annualAverage:
      json['annual_average'] ?? '',


    );

  }

}







class Supervisor {


  final int id;

  final String fullName;

  final String email;

  final String specialization;

  final String supervisorIdentifier;

  final String certificatePlace;

  final String certificateDate;



  Supervisor({

    required this.id,

    required this.fullName,

    required this.email,

    required this.specialization,

    required this.supervisorIdentifier,

    required this.certificatePlace,

    required this.certificateDate,

  });



  factory Supervisor.fromJson(Map<String,dynamic> json){


    return Supervisor(


      id:
      json['id'] ?? 0,



      fullName:
      json['full_name'] ?? '',



      email:
      json['email'] ?? '',



      specialization:
      json['specialization'] ?? '',



      supervisorIdentifier:
      json['supervisor_identifier'] ?? '',



      certificatePlace:
      json['certificate_place'] ?? '',



      certificateDate:
      json['certificate_date'] ?? '',


    );

  }

}