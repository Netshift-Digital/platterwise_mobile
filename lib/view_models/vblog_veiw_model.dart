import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/vblog_services.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/post_data.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/comment_reply.dart';
import 'package:platterwave/model/vblog/like_user.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/model/vblog/top_tags.dart';
import 'package:platterwave/model/vblog/user_activity.dart';
import 'package:platterwave/model/vblog/user_search.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/enum/notification_type.dart';
import 'package:platterwave/utils/enum/saerch_type.dart';
import 'package:platterwave/utils/locator.dart';

class VBlogViewModel extends BaseViewModel {
  VBlogService vBlogService = locator<VBlogService>();
  List<Post> posts = [];
  List<Post> myPosts = [];
  List<Post> trendingPostBaseLike = [];
  List<Post> trendingPostBaseComment = [];
  List<UserProfile> myFellows = [];
  List<UserProfile> following = [];
  List<Post> myLikes = [];
  String baseOn = "baselike";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  List<AllTagRank> topTags = [];
  AppState reportAppState = AppState.idle;
  AppState postAppState = AppState.idle;
  int _postIndex = 0;
  bool postEnd = false;
  List<SearchResultElement> searchUserResult = [];
  SearchType searchType = SearchType.user;

  setSearchType(SearchType s) {
    searchType = s;
    notifyListeners();
  }

  Future<List<Post>?> getPost({bool restart = false}) async {
    try {
      if (restart) {
        _postIndex = 0;
        postEnd = false;
      }
      if (!postEnd) {
        _postIndex = _postIndex + 1;
        postAppState = AppState.busy;
        notifyListeners();
        var data = await vBlogService.getPost(_postIndex);
        postAppState = AppState.idle;
        notifyListeners();
        if (data != null) {
          var post = PostModel.fromJson(data as Map);
          //posts=[];
          if (restart) {
            posts = [];
          }
          for (var element in post.allUsersPosts) {
            posts.add(element);
          }
          if (post.allUsersPosts.length < 10) {
            postEnd = true;
          }
          notifyListeners();
          return posts;
        }
      }
    } catch (e) {
      postAppState = AppState.idle;
      notifyListeners();
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>?> getLikedPost(String id) async {
    try {
      var data = await vBlogService.getLikedPost(id);
      if (data != null) {
        var post = PostModel.fromJson(data as Map);
        return post.allUsersPosts;
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>?> getMyPost() async {
    try {
      var data = await vBlogService
          .getUserPost(FirebaseAuth.instance.currentUser!.uid);
      if (data != null) {
        var p = PostModel.fromJson(data as Map);
        myPosts = [];
        for (var element in p.allUsersPosts) {
          myPosts.add(element);
        }
        notifyListeners();
        return myPosts;
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return null;
  }
  Future<List<AllLikerDetails>> getLikeUser(int postId) async {
    try {
      var data = await vBlogService
          .getPostLikes(postId);
      if (data != null) {
        var p = LikeUsers.fromJson(data);
        return p.allLikerDetails??[];
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return [];
  }

  Future<List<AllTagRank>?> getTopTag() async {
    try {
      var data = await vBlogService.getTopTags();
      if (data != null) {
        var p = TopTag.fromJson(data as Map);
        topTags = [];
        topTags = p.allTagRank;
        notifyListeners();
        return topTags;
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<Post?> getMyPostById(String postId) async {
    try {
      setState(AppState.busy);
      var data = await vBlogService.getPostById(postId);
      setState(AppState.idle);
      if (data != null) {
        var p = PostModel.fromJson(data as Map);
        List<Post> posts = [];
        for (var element in p.allUsersPosts) {
          posts.add(element);
        }
        notifyListeners();
        return posts.first;
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>?> getUserPost(String id) async {
    try {
      var data = await vBlogService.getUserPost(id);
      if (data != null) {
        var p = PostModel.fromJson(data as Map);
        notifyListeners();
        return p.allUsersPosts;
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<UsersComment>> getComment(int postId) async {
    List<UsersComment> comments = [];
    try {
      var data = await vBlogService.getComment(postId);
      if (data != null) {
        var comment = CommentModel.fromJson(data as Map);
        for (var element in comment.allUsersComments) {
          if (element.comment.toString().isNotEmpty) {
            comments.add(element);
          }
        }
        notifyListeners();
        return comments;
      }
    } catch (e) {
      // print(e);
      setState(AppState.idle);
    }
    return comments;
  }

  Future<dynamic> likePost(Post p, UserProfile userData) async {
    try {
      myLikes.add(p);
      FirebaseFirestore.instance
          .collection("likes")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(p.postId.toString())
          .set(p.toJson());
      var data = await vBlogService.likePost(
          int.parse(p.postId), FirebaseAuth.instance.currentUser!.uid);
      if (data != null) {
        addActivity(
            p.firebaseAuthId,
            UserActivity(
              id: p.postId,
              type: NotificationType.post.toString(),
              message: " liked your post",
              firebaseAuthId: FirebaseAuth.instance.currentUser!.uid,
              userName: userData.username,
              profilePic: userData.profileUrl,
            ));
      }
    } catch (e) {
      setState(AppState.idle);
    }
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> commentOnPost(int postId, String uid, String comment,
      {required UserProfile userData, required String id}) async {
    try {
      var data = await vBlogService.commentToPost(postId, uid, comment);
      if (data != null) {
        addActivity(
            id,
            UserActivity(
                id: postId.toString(),
                type: NotificationType.post.toString(),
                message: " commented on your post",
                firebaseAuthId: FirebaseAuth.instance.currentUser!.uid,
                userName: userData.username,
                profilePic: userData.profileUrl));
      }
      return data;
    } catch (e) {
      setState(AppState.idle);
    }
  }

  Future<dynamic> deletePost(Post post) async {
    try {
      var data = await vBlogService.deletePost(int.parse(post.postId));
      if (data != null) {
        posts.remove(post);
        myPosts.remove(post);
        myLikes.remove(post);
        notifyListeners();
      }
      return data;
    } catch (e) {
      setState(AppState.idle);
    }
  }

  Future<dynamic> replyToComment(int commentId, String comment,
      {required UserProfile userData,
      required String id,
      required String postId}) async {
    try {
      var data = await vBlogService.replyToComment(
          commentId, FirebaseAuth.instance.currentUser!.uid, comment);
      if (data != null) {
        addActivity(
            id,
            UserActivity(
                message: " replied to a comment on your post",
                id: postId,
                type: NotificationType.post.toString(),
                firebaseAuthId: FirebaseAuth.instance.currentUser!.uid,
                userName: userData.username,
                profilePic: userData.profileUrl));
      }
    } catch (e) {
      setState(AppState.idle);
    }
  }

  Future<List<UsersReply>?> getCommentReply(int commentId) async {
    List<UsersReply> comments = [];
    try {
      var data = await vBlogService.getToCommentReply(commentId);
      if (data != null) {
        for (var element in data['users_reply']) {
          comments.add(UsersReply.fromJson(element as Map));
        }
        notifyListeners();
        return comments;
      }
    } catch (e) {
      print(e);
      setState(AppState.idle);
    }
    return comments;
  }

  Future<String?> uploadImage({Uint8List? memory, String? filePath}) async {
    try {
      var dat = "${DateTime.now().microsecondsSinceEpoch}.png";
      if (memory != null) {
        var data = await firebaseStorage.ref().child(dat).putData(memory);
        var url = await data.ref.getDownloadURL();
        return url;
      } else {
        File file = File(filePath!);
        var data = await firebaseStorage
            .ref()
            .child(file.path)
            .putData(file.readAsBytesSync());
        var url = await data.ref.getDownloadURL();
        return url;
      }
    } on FirebaseException catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<bool?> createPost(PostData postData,
      {String? imagePath, Uint8List? thumbnail}) async {
    String contentUrl = "";
    String type = postData.contentType;
    try {
      postAppState = AppState.busy;
      notifyListeners();
      if (imagePath != null) {
        var uploadedImage = await uploadImage(filePath: imagePath);
        if (uploadedImage != null) {
          contentUrl = uploadedImage!;
        }
      }
      if (thumbnail != null) {
        var uploadedThumbnail = await uploadImage(memory: thumbnail);
        if (uploadedThumbnail != null) {
          type = uploadedThumbnail!;
        }
      }
      var post = postData.copyWith(contentUrl: contentUrl, contentType: type);
      var data = await vBlogService.createPost(post);
      if (data != null) {
        handelTags(postData.contentPost, data["post_id"].toString());
      }
      postAppState = AppState.idle;
      notifyListeners();
      return true;
    } catch (e) {
      postAppState = AppState.idle;
      notifyListeners();
    }
    return null;
  }

  Future<List<UserProfile>?> getFollowers() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("followers")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .get();
      myFellows = [];
      for (var v in data.docs) {
        myFellows.add(UserProfile.fromJson(v.data()));
      }
      notifyListeners();
    } catch (e) {
      //
    }
    return null;
  }

  Future<List<UserProfile>?> getFollowing() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("following")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .get();
      following = [];
      for (var v in data.docs) {
        following.add(UserProfile.fromJson(v.data()));
      }
      notifyListeners();
    } catch (e) {
      //
    }
    return null;
  }

  Future<List<Post>?> getMyLikes(String id) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("likes")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .get();
      myLikes = [];
      for (var v in data.docs) {
        myLikes.add(Post.fromJson(v.data()));
        return myLikes;
      }
      notifyListeners();
    } catch (e) {
      //
    }
    return null;
  }

  Future<List<Post>?> getMyUserlikes(String id) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("likes")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .get();
      List<Post> likes = [];
      for (var v in data.docs) {
        likes.add(Post.fromJson(v.data()));
        return likes;
      }
      notifyListeners();
    } catch (e) {
      //
    }
    return null;
  }

  Future<dynamic> followUser(
      String uid, UserProfile users, UserProfile userToBeFollowed) async {
    try {
      following.add(users);
      notifyListeners();
      await vBlogService.fellowUser(uid);
      FirebaseFirestore.instance
          .collection("followers")
          .doc('users')
          .collection(uid)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(users.toJson());

      FirebaseFirestore.instance
          .collection("following")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(uid)
          .set(userToBeFollowed.toJson());
      following.add(users);
      notifyListeners();
      getFollowing();

      addActivity(
          uid,
          UserActivity(
              message: " started following you ",
              firebaseAuthId: uid,
              id: FirebaseAuth.instance.currentUser!.uid,
              type: NotificationType.user.toString(),
              userName: users.username,
              profilePic: users.profileUrl));
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      setState(AppState.idle);
    }
  }

  Future<dynamic> unFollowUser(String uid, UserProfile users) async {
    try {
      following.remove(users);
      notifyListeners();
      await vBlogService.unFellowUser(uid);
      FirebaseFirestore.instance
          .collection("followers")
          .doc('users')
          .collection(uid)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      FirebaseFirestore.instance
          .collection("following")
          .doc("users")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(uid)
          .delete();
      following.remove(users);
      notifyListeners();
      getFollowing();
    } catch (e) {
      setState(AppState.idle);
    }
  }

  bool getIsFollowed(String id) {
    var d = following.where((element) => element.email == id);
    return d.isNotEmpty;
  }

  bool checkIsLiked(String id) {
    var d = myLikes.where((element) => element.postId == id);
    return d.isNotEmpty;
  }

  Future<List<Post>?> searchPost(String search) async {
    try {
      var data = await vBlogService.searchPost(search);
      //print(data);
      if (data != null) {
        List<Post> searchResult = [];
        for (var e in data['search_result']) {
          var result = Post.fromJson(e);
          searchResult.add(result);
        }
        return searchResult;
      }
      setState(AppState.idle);
    } catch (e) {
      print(e);
      // RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<SearchResultElement>?> searchUser(String search) async {
    try {
      var data = await vBlogService.searchUser(search);
      //print(data);
      if (data != null) {
        var search = SearchResult.fromJson(data);
        searchUserResult = search.searchResult;
        notifyListeners();
        return searchUserResult;
      }
      setState(AppState.idle);
    } catch (e) {
      print(e);
      // RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>> getPostByTag(String tag) async {
    try {
      var data = await vBlogService.getByTag(tag);
      //print(data);
      if (data != null) {
        List<Post> searchResult = [];
        for (var e in data['search_result']) {
          var result = Post.fromJson(e);
          searchResult.add(result);
        }
        return searchResult;
      }
      setState(AppState.idle);
    } catch (e) {
      // RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return [];
  }

  addActivity(String id, UserActivity userActivity) {
    if (id != FirebaseAuth.instance.currentUser!.uid) {
      FirebaseFirestore.instance
          .collection("activity")
          .doc("users")
          .collection(id)
          .add(userActivity.toJson());

      sendNotification(
        userActivity.userName + userActivity.message,
        id,
        postId: userActivity.id,
        type: userActivity.type,
      );
    }
  }

  savePost(Post post) {
    FirebaseFirestore.instance
        .collection("savedPost")
        .doc("users")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(post.postId)
        .set(post.toJson());
  }

  deleteSavePost(String postId) {
    FirebaseFirestore.instance
        .collection("savedPost")
        .doc("users")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(postId)
        .delete();
  }

  Future<List<Post>?> getTrendingLikes({String base = "baselike"}) async {
    try {
      baseOn = base;
      var data = await vBlogService.getTrending(baseOn);
      //print(data);
      if (data != null) {
        trendingPostBaseLike = [];
        for (var e in data['trending']) {
          var p = Post.fromJson(e as Map);
          trendingPostBaseLike.add(p);
        }
        return trendingPostBaseLike;
      }
      setState(AppState.idle);
    } catch (e) {
      print(e);
      // RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>?> getTrendingOnComment(
      {String base = "basecomment"}) async {
    try {
      baseOn = base;
      var data = await vBlogService.getTrending(baseOn);
      //print(data);
      if (data != null) {
        trendingPostBaseComment = [];
        for (var e in data['trending']) {
          var p = Post.fromJson(e as Map);
          trendingPostBaseComment.add(p);
        }
        return trendingPostBaseComment;
      }
      setState(AppState.idle);
    } catch (e) {
      // RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  void handelTags(String contentPost, String postId) {
    List tag = [];
    Map jsonTag = {};
    if (contentPost.isNotEmpty) {
      var list = contentPost.split(" ");
      for (var e in list) {
        if (e.startsWith("#")) {
          tag.add(e);
          if (jsonTag.isEmpty) {
            jsonTag["tag_post"] = e;
          } else {
            jsonTag["tag_post${jsonTag.length + 1}"] = e;
          }
        }
      }
      if (jsonTag.isNotEmpty) {
        vBlogService.createTags(
            jsonTag, postId, FirebaseAuth.instance.currentUser!.uid);
      }
    }
  }

  sendNotification(String message, String topic,
      {String title = "", String? postId, String? type}) {
    vBlogService.sendNotification(message, topic,
        title: title, type: type, postId: postId);
  }

  Future<dynamic> reportPost(int postId, String uid, String comment) async {
    try {
      reportAppState = AppState.busy;
      notifyListeners();
      var data = await vBlogService.reportPost(postId, uid, comment);
      reportAppState = AppState.idle;
      notifyListeners();
      return data;
    } catch (e) {
      reportAppState = AppState.idle;
      notifyListeners();
      setState(AppState.idle);
    }
  }
}
