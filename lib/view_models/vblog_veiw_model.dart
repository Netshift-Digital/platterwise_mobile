import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/vblog_services.dart';
import 'package:platterwave/model/request_model/post_data.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';

class VBlogViewModel extends BaseViewModel{
  VBlogService vBlogService = locator<VBlogService>();
  List<Post> posts = [];
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


  Future<List<UsersComment>> getComment(int postId)async{
    List<UsersComment> comments = [];
    try{
      var data = await vBlogService.getComment(postId);
      if(data!=null){
        var comment = CommentModel.fromJson(data as Map);
        for (var element in comment.allUsersComments) {
          comments.add(element);
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


  Future<dynamic> likePost(int postId, String uid)async{
    List<UsersComment> comments = [];
    try{
     await vBlogService.likePost(postId, uid);
    }catch(e){
      setState(AppState.idle);
    }
    return comments;
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



  }