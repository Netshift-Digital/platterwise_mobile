import 'package:flutter/material.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class ViewPostsPage extends StatefulWidget {
  const ViewPostsPage({Key? key}) : super(key: key);

  @override
  State<ViewPostsPage> createState() => _ViewPostsPageState();
}

class _ViewPostsPageState extends State<ViewPostsPage> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: model.posts.length,
          itemBuilder: (context,index) {
            var data =  model.posts[index];
            if(data.firebaseAuthId!="hhjhgvv"){
              return SizedBox();
            }
            return  TimelinePostContainer(data);
          }
      ),
    );
  }
}
