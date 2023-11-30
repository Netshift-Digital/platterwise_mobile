import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';

import '../../../view_models/pageview_model.dart';

class ViewPostsPage extends StatefulWidget {
  final String? id;
  ViewPostsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewPostsPage> createState() => _ViewPostsPageState();
}

class _ViewPostsPageState extends State<ViewPostsPage> {
  int _postIndex = 0;
  List<Post> post = [];
  bool postEnd = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: post.isEmpty
          ? const EmptyContentContainer()
          : ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              controller: scrollController,
              itemCount: post.length,
              itemBuilder: (context, index) {
                var data = post[index];
                return TimelinePostContainer(data);
              }),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        getPost(restart: true);
      }
    });
    if (mounted) {
      scrollController.addListener(() {
        var model = context.read<PageViewModel>();
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          model.hideBottomNavigator();
        } else {
          model.showBottomNavigator();
        }
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          getPost(restart: false);
        }
      });
    }
  }

  void getPost({bool restart = false}) async {
    var model = context.read<VBlogViewModel>();
    if (restart) {
      _postIndex = 0;
      post = [];
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;
      if (widget.id == LocalStorage.getUserId() || widget.id == null) {
        var res = await model.getMyPost(postIndex: _postIndex);
        if (res != null) {
          if (res.length < 20) {
            postEnd = true;
          }
          setState(() {
            post.addAll(res);
          });
        }
      } else {
        var res = await model.getUserPost(widget.id!, postIndex: _postIndex);
        if (res != null) {
          if (res.length < 15) {
            postEnd = true;
          }
          setState(() {
            post.addAll(res);
          });
        }
      }
    }
  }
}
