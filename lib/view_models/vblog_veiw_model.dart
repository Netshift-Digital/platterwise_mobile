import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/vblog_services.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/post_data.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';

class VBlogViewModel extends BaseViewModel{
  VBlogService vBlogService = locator<VBlogService>();
  List<Post> posts = [];
  List<Post> myPosts = [];
  List<UserProfile> myFellows = [];
  List<UserProfile> following = [];
  List<Post> myLikes = [];
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;


  Future<List<Post>?> getPost()async{
    try{
      var data = await vBlogService.getPost();
      if(data!=null){
        var post = PostModel.fromJson(data as Map);
        posts=[];
        for (var element in post.allUsersPosts) {
          posts.add(element);
        }
        notifyListeners();
        return posts;
      }
    }catch(e){
      setState(AppState.idle);
    }
    return null;
  }


  Future<List<Post>?> getMyPost()async{
    try{
      var data = await vBlogService.getUserPost(FirebaseAuth.instance.currentUser!.uid);
      if(data!=null){
        var p = PostModel.fromJson(data as Map);
       myPosts=[];
        for (var element in p.allUsersPosts) {
          myPosts.add(element);
        }
        notifyListeners();
        return myPosts;
      }
    }catch(e){
      setState(AppState.idle);
    }
    return null;
  }

  Future<List<Post>?> getUserPost(String id)async{
    try{
      var data = await vBlogService.getUserPost(id);
      if(data!=null){
        var p = PostModel.fromJson(data as Map);
        notifyListeners();
        return p.allUsersPosts;
      }
    }catch(e){
      setState(AppState.idle);
    }
    return null;
  }


  Future<List<UsersComment>> getComment(int postId)async{
    List<UsersComment> comments = [];
    try{
      var data = await vBlogService.getComment(postId);
      if(data!=null){
        var comment = CommentModel.fromJson(data as Map);
        for (var element in comment.allUsersComments) {
          if(element.comment.toString().isNotEmpty){
            comments.add(element);
          }

        }
        notifyListeners();
        return comments;
      }
    }catch(e){
      print(e);
      setState(AppState.idle);
    }
    return comments;
  }


  Future<dynamic> likePost(Post p)async{
    try{
      myLikes.add(p);
     await vBlogService.likePost(int.parse(p.postId), FirebaseAuth.instance.currentUser!.uid);
     FirebaseFirestore.instance.collection("likes").
     doc("users").collection(FirebaseAuth.instance.currentUser!.uid).doc(p.postId.toString())
         .set(p.toJson());
    }catch(e){
      setState(AppState.idle);
    }
  }



  // ignore: non_constant_identifier_names
  Future<dynamic> commentOnPost(int postId, String uid,String comment)async{
    try{
      await vBlogService.commentToPost(postId, uid, comment);
    }catch(e){
      setState(AppState.idle);
    }
  }


  Future<String?> uploadImage(String filePath)async{
    try{
      File file = File(filePath);
      var data = await firebaseStorage.ref("vBlog").putData(file.readAsBytesSync());
      var url = await data.ref.getDownloadURL();
      return url;
    }on FirebaseException catch (e){
      setState(AppState.idle);
    }
    return null;
  }

  Future<bool?> createPost(PostData postData,{String? imagePath})async{
    String? contentUrl = "";
    try{
      setState(AppState.busy);
      if(imagePath!=null){
        contentUrl = await  uploadImage(imagePath!);
      }

      var post = postData.copyWith(
        contentUrl: contentUrl
      );
      await vBlogService.createPost(post);
      setState(AppState.idle);
      return true;
    } catch(e){
      setState(AppState.idle);
    }
    return null;
  }

Future<List<UserProfile>?>getFollowers()async{
    try{
     var data = await FirebaseFirestore.instance.collection("followers").doc("users").collection(FirebaseAuth.instance.currentUser!.uid).
      get();
     myFellows=[];
     for(var v in data.docs){
       myFellows.add(UserProfile.fromJson(v.data()));
     }
     notifyListeners();
    }catch(e){
  //
    }
    return null;
}

  Future<List<UserProfile>?> getFollowing()async{
    try{
      var data = await FirebaseFirestore.instance.collection("following").doc("users").collection(FirebaseAuth.instance.currentUser!.uid).
      get();
      following=[];
      for(var v in data.docs){
        following.add(UserProfile.fromJson(v.data()));
      }
      notifyListeners();
    }catch(e){
      //
    }
  }

  Future<List<Post>?> getMylikes(String id)async{
    try{
      var data = await FirebaseFirestore.instance.collection("likes").
      doc("users").collection(FirebaseAuth.instance.currentUser!.uid).
      get();
      myLikes=[];
      for(var v in data.docs){
        myLikes.add(Post.fromJson(v.data()));
        return myLikes;
      }
      notifyListeners();
    }catch(e){
      //
    }
  }

  Future<List<Post>?> getMyUserlikes(String id)async{
    try{
      var data = await FirebaseFirestore.instance.collection("likes").
      doc("users").collection(FirebaseAuth.instance.currentUser!.uid).
      get();
      List<Post> likes=[];
      for(var v in data.docs){
        likes.add(Post.fromJson(v.data()));
        return likes;
      }
      notifyListeners();
    }catch(e){
      //
    }
  }


  Future<dynamic> followUser(String uid,UserProfile users )async{
    try{
      following.add(users);
      notifyListeners();
      await vBlogService.fellowUser(uid);
      FirebaseFirestore.instance.collection("followers").doc('users').collection(uid).doc(FirebaseAuth.instance.currentUser!.uid).set(users.toJson());
      FirebaseFirestore.instance.collection("following").
      doc("users").collection(FirebaseAuth.instance.currentUser!.uid).doc(uid)
          .set(users.toJson());


    }on FirebaseException catch (e){
      print(e);
    }
    catch(e){
      setState(AppState.idle);
    }
  }

  Future<dynamic> unFollowUser(String uid,UserProfile users)async{
    try{
      following.remove(users);
      notifyListeners();
      await vBlogService.unFellowUser(uid);
      FirebaseFirestore.instance.collection("followers").doc('users').collection(uid).doc(FirebaseAuth.instance.currentUser!.uid).delete();
      FirebaseFirestore.instance.collection("following").
      doc("users").collection(FirebaseAuth.instance.currentUser!.uid).doc(uid)
          .delete();
    }catch(e){
      setState(AppState.idle);
    }
  }

  bool getIsFollowed(String id){
    var d = following.where((element) =>element.email==id );
    return d.isNotEmpty;
  }

  bool checkIsLiked(String id){
    var d = myLikes.where((element) =>element.postId==id );
    return d.isNotEmpty;
  }

  }