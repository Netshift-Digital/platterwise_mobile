import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class ViewLikesPage extends StatefulWidget {
  final String? id;
  ViewLikesPage({Key? key, this.id}) : super(key: key);

  @override
  State<ViewLikesPage> createState() => _ViewLikesPageState();
}

class _ViewLikesPageState extends State<ViewLikesPage> {
  final searchTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Post> postList = [];

  int _postIndex = 0;
  bool postEnd = false;
  @override
  Widget build(BuildContext context) {
    return postList.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: EmptyContentContainer(
                errorText: "Like your first post by going to homepage "
                    "and follow the accounts you are intrested in",
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  var post = postList[index];
                  return TimelinePostContainer(post);
                }),
          );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () async {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          getLikedPost(restart: true);
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
            getLikedPost(restart: false);
          }
        });
      }
    });
  }

  void getLikedPost({bool restart = false}) async {
    var model = context.read<VBlogViewModel>();
    if (restart) {
      _postIndex = 0;
      postList = [];
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;
      var res = await model.getLikedPost(widget.id ?? LocalStorage.getUserId(),
          restart: restart, postIndex: _postIndex);
      if (res!.isNotEmpty) {
        setState(() {
          postList.addAll(res);
        });
        if (res.isEmpty || res.length < 30) {
          postEnd = true;
        }
      }
    }
  }
}
