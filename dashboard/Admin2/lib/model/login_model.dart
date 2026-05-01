
import 'dart:convert';



Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));



String welcomeToJson(Welcome data) => json.encode(data.toJson());



class Welcome {

int statusCode;

String message;

Data data;



Welcome({

required this.statusCode,

required this.message,

required this.data,

});



factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(

statusCode: json["status_code"],

message: json["message"],

data: Data.fromJson(json["data"]),

);



Map<String, dynamic> toJson() => {

"status_code": statusCode,

"message": message,

"data": data.toJson(),

};

}



class Data {

String token;

Admin admin;



Data({

required this.token,

required this.admin,

});



factory Data.fromJson(Map<String, dynamic> json) => Data(

token: json["token"],

admin: Admin.fromJson(json["admin"]),

);



Map<String, dynamic> toJson() => {

"token": token,

"admin": admin.toJson(),

};

}



class Admin {

int id;

String name;

String email;



Admin({

required this.id,

required this.name,

required this.email,

});



factory Admin.fromJson(Map<String, dynamic> json) => Admin(

id: json["id"],

name: json["name"],

email: json["email"],

);



Map<String, dynamic> toJson() => {

"id": id,

"name": name,

"email": email,

};

}

