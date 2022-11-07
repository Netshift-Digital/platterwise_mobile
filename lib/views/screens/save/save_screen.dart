import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/data/local/post.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/vblog/post_details.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/tiles/saved_post_tile.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var post = LocalPost().getPost();
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("savedPost").
        doc("users").collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return snapshot.data!.docs.isEmpty?
         const  Center(child:  EmptyContentContainer(
           errorText: "No save post !",
         )):
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: ListView.builder(
                itemCount:snapshot.data!.docs.length,
                itemBuilder:(context,index){
                  var data = snapshot.data!.docs[index].data() as Map;
                  var postData= Post.fromJson(data);
                  return SavedPostTile(
                    post: postData,
                    onTap: (){
                      nav(context, PostDetails(post: postData));
                    },
                  );
                },
              ),
            );

          }else{
            return const Center(
              child:   EmptyContentContainer(
                errorText: "No save post !",
              ),
            );
          }
        }
      ),
    );
  }
}
