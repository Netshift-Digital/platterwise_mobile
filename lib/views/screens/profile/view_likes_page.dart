import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';


String lastId = "noting";
List<Post> postList = [];
class ViewLikesPage extends StatefulWidget {
 final String? id;
  const ViewLikesPage({Key? key, this.id}) : super(key: key);

  @override
  State<ViewLikesPage> createState() => _ViewLikesPageState();
}

class _ViewLikesPageState extends State<ViewLikesPage> {

  @override
  Widget build(BuildContext context) {
    return postList.isEmpty?
    const  Center(
    child:   Padding(
        padding:  EdgeInsets.only(left: 20,right: 20),
        child: EmptyContentContainer(
          errorText: "Like your first post by going to homepage "
              "and follow the accounts you are intrested in",
        ),
      ),
  ) :Padding(
      padding:  const EdgeInsets.only(left: 20,right: 20),
    child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: postList.length,
          itemBuilder: (context,index) {
            var post = postList[index];;
            return  TimelinePostContainer(post);
          }
      ),
  );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 10),()async{
      var id = widget.id??FirebaseAuth.instance.currentUser!.uid;
      if(lastId!=id){
        setState(() {
          postList=[];
        });
        var blogModel = context.read<VBlogViewModel>();
        var data = await blogModel.getLikedPost(widget.id??FirebaseAuth.instance.currentUser!.uid);
        if(data!=null){
          if(mounted){
            setState(() {
              postList=data;
              lastId=widget.id??FirebaseAuth.instance.currentUser!.uid;
            });
          }
        }
      }


    });
  }
}
