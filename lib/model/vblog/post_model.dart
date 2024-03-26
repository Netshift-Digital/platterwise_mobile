// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

import 'package:platterwave/model/profile/user_data.dart';

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
        allUsersPosts: List<Post>.from(
            json["all_users_posts"].map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "all_users_posts":
            List<dynamic>.from(allUsersPosts.map((x) => x.toJson())),
      };
}

class Post {
  Post(
      {required this.contentPost,
      required this.postId,
      required this.contentType,
      required this.contentUrl,
      required this.timestamp,
      required this.commentCount,
      required this.type,
      required this.likeCount,
      required this.tags,
      required this.user,
      required this.commentReply,
      required this.liked});

  String contentPost;
  int postId;
  String contentType;
  String contentUrl;
  DateTime timestamp;
  int commentCount;
  int likeCount;
  String type = "user";
  List tags;
  UserProfile user;
  bool liked;
  dynamic commentReply;

  factory Post.fromJsonPost(Map<dynamic, dynamic> json) => Post(
      contentPost: json["post"]["content_post"] ?? "",
      postId: json["post"]["id"] ?? 20,
      contentType: json["post"]["content_type"] ?? "image",
      contentUrl: json["post"]["contentUrl"] ??
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png",
      timestamp: json["post"]["created_at"] == null
          ? DateTime.now()
          : DateTime.parse(json["post"]["created_at"]),
      commentCount: json["post"]["total_comments"] ?? 0,
      type: json["type"] ?? "user",
      user: json["user"] != null
          ? UserProfile.fromJson(json["user"])
          : json["admin"] != null
              ? UserProfile.fromJson(json["admin"])
              : UserProfile.empty(),
      likeCount: json["post"]['total_likes'] ?? 0,
      tags: json["post"]['taggs'] ?? [],
      commentReply: json["post"]['comment_reply'] ?? "",
      liked: json["post"]['is_liked'] ?? false);

  factory Post.fromJson(Map<dynamic, dynamic> json) => Post(
      contentPost: json["content_post"] ?? "",
      postId: json["id"] ?? 20,
      contentType: json["content_type"] ?? "image",
      contentUrl: json["contentUrl"] ??
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png",
      timestamp: json["created_at"] == null
          ? DateTime.now()
          : DateTime.parse(json["created_at"]),
      commentCount: json["total_comments"] ?? 0,
      type: json["type"] ?? "user",
      user: json["user"] != null
          ? UserProfile.fromJson(json["user"])
          : json["admin"] != null
              ? UserProfile.fromJson(json["admin"])
              : UserProfile.empty(),
      likeCount: json['total_likes'] ?? 0,
      tags: json['taggs'] ?? [],
      commentReply: json['comment_reply'] ?? "",
      liked: json['is_liked'] ?? false);

  Map<String, dynamic> toJson() => {
        "content_post": contentPost,
        "post_id": postId,
        "content_type": contentType,
        "contentUrl": contentUrl,
        "timestamp": timestamp.toIso8601String(),
        "taggs": tags
      };
}
