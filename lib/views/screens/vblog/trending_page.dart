import 'package:flutter/material.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    return Scaffold(
      body: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
        itemCount: model.posts.length,
        itemBuilder: (context,index) {
            var data =  model.posts[index];
          return  TimelinePostContainer(data);
        }
      ),
    );
  }
}
