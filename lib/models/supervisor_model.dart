class SupervisorModel {

  final int id;
  final String fullName;
  final String email;
  final String supervisorIdentifier;
  final String specialization;
  final String certificatePlace;
  final String certificateDate;

  SupervisorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.supervisorIdentifier,
    required this.specialization,
    required this.certificatePlace,
    required this.certificateDate,
  });

  factory SupervisorModel.fromJson(
      Map<String, dynamic> json) {

    return SupervisorModel(
      id: json['id'] ?? 0,

      fullName:
          json['full_name'] ?? '',

      email:
          json['email'] ?? '',

      supervisorIdentifier:
          json['supervisor_identifier'] ?? '',

      specialization:
          json['specialization'] ?? '',

      certificatePlace:
          json['certificate_place'] ?? '',

      certificateDate:
          json['certificate_date'] ?? '',
    );
  }
}