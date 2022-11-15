// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    required this.status,
    required this.allUsersComments,
  });

  dynamic status;
  List<UsersComment> allUsersComments;

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) => CommentModel(
    status: json["status"]??"",
    allUsersComments: List<UsersComment>.from(json["all_users_comments"].map((x) => UsersComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_users_comments": List<dynamic>.from(allUsersComments.map((x) => x.toJson())),
  };
}

class UsersComment {
  UsersComment({
    required this.contentPost,
    required this.postType,
    required this.username,
    required this.comment,
    required this.profileUrl,
    required  this.timestamp,
    this.commentId,
  });

  dynamic contentPost;
  dynamic postType;
  dynamic username;
  dynamic comment;
  dynamic profileUrl;
  dynamic commentId;
  DateTime timestamp;

  factory UsersComment.fromJson(Map<String, dynamic> json) => UsersComment(
    contentPost: json["content_post"]??"",
    postType: json["post_type"]??"",
    username: json["username"]??"User",
    comment: json["comment"]??"",
    profileUrl: json["profileURL"] ??"https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png",
    timestamp:json["timestamp"]==null?DateTime.now():DateTime.parse(json["timestamp"]),
    commentId: json['comment_id']??"0"
  );

  Map<String, dynamic> toJson() => {
    "content_post": contentPost,
    "post_type": postType,
    "username": username,
    "comment": comment,
    "profileURL": profileUrl == null ? null : profileUrl,
    "timestamp": timestamp.toIso8601String(),
    "comment_id":commentId
  };
}
