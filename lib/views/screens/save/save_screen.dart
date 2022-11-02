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
      body: post.isEmpty?const Center(child: EmptyContentContainer(

      )):Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child:ListView.builder(
          itemCount: post.length ,
          itemBuilder:(context,index){
            var data = post[index] as Map;
            var postData= Post.fromJson(data);
            return SavedPostTile(
              post: postData,
              onTap: (){
                nav(context, PostDetails(post: postData));
              },
            );
          },
        ),
      ),
    );
  }
}
