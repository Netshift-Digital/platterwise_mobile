// To parse this JSON data, do
//
//     final postData = postDataFromJson(jsonString);

import 'dart:convert';

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));

String postDataToJson(PostData data) => json.encode(data.toJson());

class PostData {
  PostData({
   required this.userId,
   required this.contentPost,
    required  this.contentType,
    required this.contentUrl,
    required this.profileUrl,
    required this.username,
    required  this.firebaseAuthId,
  });

  int userId;
  String contentPost;
  String contentType;
  String contentUrl;
  String profileUrl;
  String username;
  String firebaseAuthId;

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
    userId: json["user_id"],
    contentPost: json["content_post"],
    contentType: json["content_type"],
    contentUrl: json["contentUrl"],
    profileUrl: json["profileURL"],
    username: json["username"],
    firebaseAuthId: json["firebaseAuthID"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "content_post": contentPost,
    "content_type": contentType,
    "contentUrl": contentUrl,
    "profileURL": profileUrl,
    "username": username,
    "firebaseAuthID": firebaseAuthId,
  };
}
