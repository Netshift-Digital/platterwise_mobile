// To parse this JSON data, do
//
//     final userActivity = userActivityFromJson(jsonString);

import 'dart:convert';

UserActivity userActivityFromJson(String str) =>
    UserActivity.fromJson(json.decode(str));

String userActivityToJson(UserActivity data) => json.encode(data.toJson());

class UserActivity {
  UserActivity({
    required this.message,
    required this.firebaseAuthId,
    required this.userName,
    required this.profilePic,
    required this.id,
    required this.type,
    this.time,
  });

  String message;
  String type;
  String firebaseAuthId, id;
  String? time;
  String userName;
  String profilePic;

  UserActivity copyWith(
          {String? message,
          String? firebaseAuthId,
          String? userName,
          String? profilePic,
          String? id,
          String? type}) =>
      UserActivity(
        id: id ?? this.id,
        type: type ?? this.type,
        message: message ?? this.message,
        firebaseAuthId: firebaseAuthId ?? this.firebaseAuthId,
        userName: userName ?? this.userName,
        profilePic: profilePic ?? this.profilePic,
      );

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
      message: json["message"],
      id: json['id'] ?? "",
      type: json['type'] ?? "",
      firebaseAuthId: json["firebaseAuthID"],
      userName: json["userName"],
      profilePic: json["profile pic"],
      time: json['time'] ?? DateTime.now().toString());

  Map<String, dynamic> toJson() => {
        "message": message,
        "firebaseAuthID": firebaseAuthId,
        "userName": userName,
        "profile pic": profilePic,
        "time": DateTime.now().toString(),
        "id": id,
        "type": type
      };
}
