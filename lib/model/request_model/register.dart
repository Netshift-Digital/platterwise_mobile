// To parse this JSON data, do
//
//     final signUp = signUpFromJson(jsonString);

import 'dart:convert';

RegisterModel signUpFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String signUpToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
   required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.username,
  });

  String fullName;
  String email;
  String password;
  String phone;
  String username;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    fullName: json["full_name"],
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    "password": password,
    "phone": phone,
    "username": username,
  };
}
