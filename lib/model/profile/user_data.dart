// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
   required this.status,
   required this.userProfile,
  });

  String status;
  UserProfile userProfile;

  UserData copyWith({
    String? status,
    UserProfile? userProfile,
  }) =>
      UserData(
        status: status ?? this.status,
        userProfile: userProfile ?? this.userProfile,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    status: json["status"],
    userProfile: UserProfile.fromJson(json["user_profile"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user_profile": userProfile.toJson(),
  };
}

class UserProfile {
  UserProfile({
   required this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    required  this.phone,
    required  this.bio,
    required  this.profileUrl,
    required  this.location,
  });

  String userId;
  String fullName;
  String username;
  String email;
  String phone;
  dynamic bio;
  String profileUrl;
  dynamic location;

  UserProfile copyWith({
    String? userId,
    String? fullName,
    String? username,
    String? email,
    String? phone,
    dynamic bio,
    String? profileUrl,
    dynamic location,
  }) =>
      UserProfile(
        userId: userId ?? this.userId,
        fullName: fullName ?? this.fullName,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        bio: bio ?? this.bio,
        profileUrl: profileUrl ?? this.profileUrl,
        location: location ?? this.location,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json["user_id"],
    fullName: json["full_name"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"]??"",
    bio: json["bio"]??"",
    profileUrl: json["profileURL"]??"'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png'",
    location: json["location"]??"",
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "full_name": fullName,
    "username": username,
    "email": email,
    "phone": phone,
    "bio": bio,
    "profileURL": profileUrl,
    "location": location,
  };
}
