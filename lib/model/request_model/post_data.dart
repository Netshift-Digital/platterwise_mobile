// To parse this JSON data, do
//
//     final postData = postDataFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));

String postDataToJson(PostData data) => json.encode(data.toJson());

class PostData {
  PostData({
   required this.userId,
    required this.contentPost,
    required this.contentType,
    required this.contentUrl,
  });

  int userId;
  String contentPost;
  String contentType;
  String contentUrl;


  PostData copyWith({
    int? userId,
    String? contentPost,
    String? contentType,
    String? contentUrl,
  }) =>
      PostData(
        userId: userId ?? this.userId,
        contentPost: contentPost ?? this.contentPost,
        contentType: contentType ?? this.contentType,
        contentUrl: contentUrl ?? this.contentUrl,
      );

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
    userId: json["user_id"],
    contentPost: json["content_post"],
    contentType: json["content_type"],
    contentUrl: json["contentUrl"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "content_post": contentPost,
    "content_type": contentType,
    "contentUrl": contentUrl,
  };
}
