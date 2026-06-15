class WarningModel {

  final int id;
  final String title;
  final String description;
  final String warningDate;
  final String possiblePenalty;


  WarningModel({

    required this.id,
    required this.title,
    required this.description,
    required this.warningDate,
    required this.possiblePenalty,

  });



  factory WarningModel.fromJson(
      Map<String,dynamic> json
      ){

    return WarningModel(

      id: json['id'] ?? 0,

      title:
      json['title'] ?? '',

      description:
      json['description'] ?? '',

      warningDate:
      json['warning_date'] ?? '',

      possiblePenalty:
      json['possible_penalty'] ?? '',

    );

  }


}