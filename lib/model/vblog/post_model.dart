// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    required this.status,
    required this.allUsersPosts,
  });

  String status;
  List<Post> allUsersPosts;

  factory PostModel.fromJson(Map<dynamic, dynamic> json) => PostModel(
    status: json["status"],
    allUsersPosts: List<Post>.from(json["all_users_posts"].map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_users_posts": List<dynamic>.from(allUsersPosts.map((x) => x.toJson())),
  };
}

class Post {
  Post({
    required this.contentPost,
    required  this.postId,
    required  this.contentType,
    required  this.profileUrl,
    required  this.contentUrl,
    required  this.username,
    required  this.firebaseAuthId,
    required  this.timestamp,
    required this.commentCount,
    required this.likeCount
  });

  String contentPost;
  String postId;
  String contentType;
  String profileUrl;
  String contentUrl;
  String username;
  String firebaseAuthId;
  DateTime timestamp;
  dynamic commentCount;
  dynamic likeCount;

  factory Post.fromJson(Map<dynamic, dynamic> json) => Post(
    contentPost: json["content_post"]??"",
    postId: json["post_id"]??"20",
    contentType: json["content_type"]??"image",
    profileUrl: json["profileURL"] ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png',
    contentUrl: json["contentUrl"] ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png",
    username: json["username"]??"user",
    firebaseAuthId: json["firebaseAuthID"] ?? "",
    timestamp:json["timestamp"]==null? DateTime.now():DateTime.parse(json["timestamp"]),
    commentCount: json["comment_count"] ?? "0",
    likeCount: json['like_count']??"0",
  );

  Map<String, dynamic> toJson() => {
    "content_post": contentPost,
    "post_id": postId,
    "content_type": contentType == null ? null : contentType,
    "profileURL": profileUrl == null ? null : profileUrl,
    "contentUrl": contentUrl == null ? null : contentUrl,
    "username": username,
    "firebaseAuthID": firebaseAuthId == null ? null : firebaseAuthId,
    "timestamp": timestamp.toIso8601String(),
  };
}
