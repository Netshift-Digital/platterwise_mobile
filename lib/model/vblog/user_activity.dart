// To parse this JSON data, do
//
//     final userActivity = userActivityFromJson(jsonString);

import 'dart:convert';

UserActivity userActivityFromJson(String str) => UserActivity.fromJson(json.decode(str));

String userActivityToJson(UserActivity data) => json.encode(data.toJson());

class UserActivity {
  UserActivity({
   required this.message,
    required this.firebaseAuthId,
    required this.userName,
    required  this.profilePic,
    this.time,
  });

  String message;
  String firebaseAuthId;
  String? time;
  String userName;
  String profilePic;

  UserActivity copyWith({
    String? message,
    String? firebaseAuthId,
    String? userName,
    String? profilePic,
  }) =>
      UserActivity(
        message: message ?? this.message,
        firebaseAuthId: firebaseAuthId ?? this.firebaseAuthId,
        userName: userName ?? this.userName,
        profilePic: profilePic ?? this.profilePic,
      );

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
    message: json["message"],
    firebaseAuthId: json["firebaseAuthID"],
    userName: json["userName"],
    profilePic: json["profile pic"],
    time: json['time']??DateTime.now().toString()
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "firebaseAuthID": firebaseAuthId,
    "userName": userName,
    "profile pic": profilePic,
    "time":DateTime.now().toString()
  };
}
