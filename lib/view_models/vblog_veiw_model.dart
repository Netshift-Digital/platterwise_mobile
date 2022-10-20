import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/vblog_services.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';

class VBlogViewModel extends BaseViewModel{
  VBlogService vBlogService = locator<VBlogService>();
  List<Post> posts = [];


  Future<List<Post>?> getPost()async{
    try{
      var data = await vBlogService.getPost();
      if(data!=null){
        var post = PostModel.fromJson(data as Map);
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
  Future<dynamic> CommentOnPost(int postId, String uid,String comment)async{
    try{
      await vBlogService.commentToPost(postId, uid, comment);
    }catch(e){
      setState(AppState.idle);
    }
  }
}