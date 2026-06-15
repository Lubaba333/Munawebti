class ViolationModel {

  final int id;
  final String title;
  final String description;
  final String violationDate;
  final String penalty;
  final String category;


  ViolationModel({

    required this.id,
    required this.title,
    required this.description,
    required this.violationDate,
    required this.penalty,
    required this.category,

  });



  factory ViolationModel.fromJson(
      Map<String,dynamic> json){

    return ViolationModel(

      id: json['id'] ?? 0,

      title:
      json['title'] ?? '',


      description:
      json['description'] ?? '',


      violationDate:
      json['violation_date'] ?? '',


      penalty:
      json['penalty'] ?? '',


      category:
      json['category'] ?? '',

    );

  }



  ViolationModel copyWith({

    String? title,
    String? description,
    String? violationDate,
    String? penalty,
    String? category,

  }){

    return ViolationModel(

      id: id,

      title:
      title ?? this.title,


      description:
      description ?? this.description,


      violationDate:
      violationDate ?? this.violationDate,


      penalty:
      penalty ?? this.penalty,


      category:
      category ?? this.category,

    );

  }


}