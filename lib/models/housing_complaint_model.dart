class HousingComplaint {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String? adminResponse;

  final Creator creator;

  HousingComplaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.adminResponse,
    required this.creator,
  });

  factory HousingComplaint.fromJson(Map<String, dynamic> json) {
    return HousingComplaint(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      adminResponse: json['admin_response'],
      creator: Creator.fromJson(json['creator']),
    );
  }
}

class Creator {
  final int id;
  final String fullName;
  final String email;
  final String specialization;
  final String supervisorIdentifier;

  Creator({
    required this.id,
    required this.fullName,
    required this.email,
    required this.specialization,
    required this.supervisorIdentifier,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      specialization: json['specialization'],
      supervisorIdentifier: json['supervisor_identifier'],
    );
  }
}