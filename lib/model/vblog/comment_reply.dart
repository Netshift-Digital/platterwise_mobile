class CommentReply {
  String? status;
  List<UsersReply>? usersReply;

  CommentReply({this.status, this.usersReply});

  CommentReply.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    if (json['users_reply'] != null) {
      usersReply = <UsersReply>[];
      json['users_reply'].forEach((v) {
        usersReply!.add(UsersReply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.usersReply != null) {
      data['users_reply'] = this.usersReply!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsersReply {
  String? userId;
  dynamic firebaseAuthID;
  String? fullName;
  String? username;
  String? commentId;
  String? replyPost;
  String? profileURL;
  String? timestampo;

  UsersReply(
      {this.userId,
        this.firebaseAuthID,
        this.fullName,
        this.username,
        this.commentId,
        this.replyPost,
        this.profileURL,
        this.timestampo});

  UsersReply.fromJson(Map<dynamic, dynamic> json) {
    userId = json['user_id'];
    firebaseAuthID = json['firebaseAuthID']??"";
    fullName = json['full_name'];
    username = json['username'];
    commentId = json['comment_id'];
    replyPost = json['reply_post'];
    profileURL = json['profileURL'];
    timestampo = json['timestampo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['firebaseAuthID'] = this.firebaseAuthID;
    data['full_name'] = this.fullName;
    data['username'] = this.username;
    data['comment_id'] = this.commentId;
    data['reply_post'] = this.replyPost;
    data['profileURL'] = this.profileURL;
    data['timestampo'] = this.timestampo;
    return data;
  }
}
