import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';

class ViewLikesPage extends StatefulWidget {
 final String? id;
  const ViewLikesPage({Key? key, this.id}) : super(key: key);

  @override
  State<ViewLikesPage> createState() => _ViewLikesPageState();
}

class _ViewLikesPageState extends State<ViewLikesPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("likes").
      doc("users").collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          //var post = Post.fromJson(snapshot.data.)
          return snapshot.data!.docs.isEmpty?
         const Center(
            child: Padding(
              padding:  EdgeInsets.only(left: 20,right: 20),
              child: EmptyContentContainer(
                errorText: "Like your first post by going to homepage "
                    "and follow the accounts you are intrested in",
              ),
            ),
          ) :Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index) {
                  var data = snapshot.data!.docs[index].data() as Map;
                  var post =  Post.fromJson(data);


                  return  TimelinePostContainer(post);
                }
            ),
          );
        }
        return const Center(
          child: Padding(
            padding:  EdgeInsets.only(left: 20,right: 20),
            child: EmptyContentContainer(
              errorText: "Like your first post by going to homepage "
                  "and follow the accounts you are intrested in",
            ),
          ),
        );
      }
    );
  }
}
