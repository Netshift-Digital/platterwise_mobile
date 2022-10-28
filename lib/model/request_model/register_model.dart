// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.username,
   this.imageUrl='',
    this.authId='',
  });

  String fullName;
  String email;
  String password;
  String phone;
  String username;
  String imageUrl;
  String authId;

  RegisterModel copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phone,
    String? username,
    String? imageUrl,
    String? authId,
  }) =>
      RegisterModel(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        username: username ?? this.username,
        imageUrl: imageUrl ?? this.imageUrl,
        authId: authId ?? this.authId,
      );

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    fullName: json["full_name"],
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    username: json["username"],
    imageUrl: json["imageUrl"],
    authId: json["authID"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    "password": password,
    "phone": phone,
    "username": username,
    "profileURL": imageUrl,
    "firebaseAuthID": authId,
  };
}
