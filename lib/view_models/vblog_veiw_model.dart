import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/local/local_storage.dart';
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
import 'package:platterwave/utils/random_functions.dart';

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
//  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
          var post = List<Post>.from(data["data"].map((x) => Post.fromJson(x)));
          posts = post;
          if (restart) {
            posts = [];
          }
          if (data["per_page"] > data["total"]) {
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
      var data = await vBlogService.getLikedPost(1);
      if (data != null) {
        var post = List<Post>.from(data["data"].map((x) => Post.fromJson(x)));
        return post;
      }
    } catch (e) {
      print(e.toString());
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>?> getMyPost() async {
    try {
      var data = await vBlogService.getUserPost(null);
      if (data != null) {
        myPosts = List<Post>.from(data["data"].map((x) => Post.fromJson(x)));
        notifyListeners();
        print("This is a single post ${myPosts[0].fullName}");
        print("This is a single post ${myPosts.length}");

        return myPosts;
      }
    } catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<AllLikerDetails>> getLikeUser(int postId) async {
    try {
      var data = await vBlogService.getPostLikes(postId);
      if (data != null) {
        var p = LikeUsers.fromJson(data);
        return p.allLikerDetails ?? [];
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
          .collection(LocalStorage.getUserId())
          .doc(p.postId.toString())
          .set(p.toJson());
      var data = await vBlogService.likePost(p.postId);
      if (data != null) {
        addActivity(
            p.userId.toString(),
            UserActivity(
              id: p.postId.toString(),
              type: NotificationType.post.toString(),
              message: " liked your post",
              firebaseAuthId: LocalStorage.getUserId(),
              userName: userData.username,
              profilePic: userData.profileUrl,
            ));
      }
    } catch (e) {
      setState(AppState.idle);
    }
  }

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
                firebaseAuthId: LocalStorage.getUserId(),
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
      var data = await vBlogService.deletePost(post.postId);
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
          commentId, LocalStorage.getUserId(), comment);
      if (data != null) {
        addActivity(
            id,
            UserActivity(
                message: " replied to a comment on your post",
                id: postId,
                type: NotificationType.post.toString(),
                firebaseAuthId: LocalStorage.getUserId(),
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

  Future<List<String>?> uploadFiles(List<String> images) async {
    var imageUrls = await Future.wait(images.map((image) => uploadFile(image)));
    return imageUrls;
  }

  Future<String> uploadFile(String image) async {
    var id = DateTime.now().toString();
    var imageName = RandomFunction.generateRandomStringWithRepetition();
    print("This is the date time image name $imageName");
    var storageReference =
        FirebaseStorage.instance.ref().child("post/" "$id/$imageName.jpg");
    var uploadTask = await storageReference.putFile(File(image));
    var url = await uploadTask.ref.getDownloadURL();
    print("This is an image url $url");
    return url;
  }

  Future<String?> uploadImage({Uint8List? memory, String? filePath}) async {
    try {
      var dat = "${DateTime.now().microsecondsSinceEpoch}.png";
      if (memory != null) {
        var data = await firebaseStorage.ref().child(dat).putData(memory);
        var url = await data.ref.getDownloadURL();
        print("An image url is $url");
        return url;
      } else {
        File file = File(filePath!);
        var data = await firebaseStorage
            .ref()
            .child(file.path)
            .putData(file.readAsBytesSync());
        var url = await data.ref.getDownloadURL();
        print("An image url is $url");
        return url;
      }
    } on FirebaseException catch (e) {
      setState(AppState.idle);
    }
    return null;
  }

  Future<bool?> createPost(
    PostData postData, {
    List<String>? imagePath,
    String? videoPath,
    Uint8List? thumbnail,
  }) async {
    String contentUrl = "";
    String type = postData.contentType;
    try {
      postAppState = AppState.busy;
      notifyListeners();
      if (imagePath != null) {
        var uploadedImage = await uploadFiles(imagePath);
        if (uploadedImage != null) {
          contentUrl = uploadedImage!.join('  ,');
        }
      }
      if (videoPath != null) {
        var uploadedImage = await uploadImage(filePath: videoPath);
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
      var post = postData.copyWith(
          contentUrl: contentUrl,
          contentType: type,
          userId: LocalStorage.getUserId());
      var data = await vBlogService.createPost(post);
      if (data != null) {
        //  handelTags(postData.contentPost, data["post_id"].toString());
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
          .collection(LocalStorage.getUserId())
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
          .collection(LocalStorage.getUserId())
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
          .collection(LocalStorage.getUserId())
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
          .collection(LocalStorage.getUserId())
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
          .doc(LocalStorage.getUserId())
          .set(users.toJson());

      FirebaseFirestore.instance
          .collection("following")
          .doc("users")
          .collection(LocalStorage.getUserId())
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
              id: LocalStorage.getUserId(),
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
          .doc(LocalStorage.getUserId())
          .delete();
      FirebaseFirestore.instance
          .collection("following")
          .doc("users")
          .collection(LocalStorage.getUserId())
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

  bool checkIsLiked(int id) {
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

  Future<List<UserProfile>?> searchUserForGuest(String search) async {
    try {
      var data = await vBlogService.searchUser(search);
      if (data != null) {
        var search = List<UserProfile>.from(
            data["data"].map((x) => UserProfile.fromJson(x)));
        notifyListeners();
        print("The user name is ${search[0].username}");

        return search;
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
    if (id != LocalStorage.getUserId()) {
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
        .collection(LocalStorage.getUserId())
        .doc(post.postId.toString())
        .set(post.toJson());
  }

  deleteSavePost(String postId) {
    FirebaseFirestore.instance
        .collection("savedPost")
        .doc("users")
        .collection(LocalStorage.getUserId())
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
        vBlogService.createTags(jsonTag, postId, LocalStorage.getUserId());
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
