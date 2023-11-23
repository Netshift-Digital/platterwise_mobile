// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'package:platterwave/model/profile/user_data.dart';

class UsersComment {
  UsersComment(
      {required this.user,
      required this.comment,
      required this.postId,
      required this.timestamp,
      required this.commentId,
      required this.commentReply});

  String comment;
  UserProfile user;
  num postId;
  num commentId;
  DateTime timestamp;
  dynamic commentReply;

  factory UsersComment.fromJson(Map<String, dynamic> json) => UsersComment(
      user: json["user"] != null
          ? UserProfile.fromJson(json["user"])
          : UserProfile.empty(),
      postId: json["post_id"] ?? 0,
      comment: json["comment"] ?? "",
      timestamp: json["created_at"] == null
          ? DateTime.now()
          : DateTime.parse(json["created_at"]),
      commentId: json['comment_id'] ?? 0,
      commentReply: json['comment_reply'] ?? "");
}
