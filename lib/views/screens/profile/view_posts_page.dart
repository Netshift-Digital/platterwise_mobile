import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class ViewPostsPage extends StatefulWidget {
 final List<Post> post;
  const ViewPostsPage({Key? key, required this.post}) : super(key: key);

  @override
  State<ViewPostsPage> createState() => _ViewPostsPageState();
}

class _ViewPostsPageState extends State<ViewPostsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child:widget.post.isEmpty?
      const EmptyContentContainer():ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.post.length,
          itemBuilder: (context,index) {
            var data =  widget.post[index];

            return  TimelinePostContainer(data);
          }
      ),
    );
  }
}
