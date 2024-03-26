import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';

class FollowingTab extends StatefulWidget {
  FollowingTab({super.key});

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab> {
  ScrollController scrollController = ScrollController();

  int _postIndex = 0;
  bool postEnd = false;

  @override
  Widget build(BuildContext context) {
    var model = context.read<VBlogViewModel>();
    return RefreshIndicator(
        onRefresh: () async {
          if (mounted) {
            getPost(restart: true);
          }
          return;
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Consumer<VBlogViewModel>(
                builder: (context, vBlogModel, child) {
                  final posts = vBlogModel.allposts;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var data = posts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TimelinePostContainer(data),
                      );
                    },
                  );
                },
              ),
              model.postAppState == AppState.busy
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[200]!,
                        valueColor: const AlwaysStoppedAnimation(AppColor.p200),
                      ),
                    )
                  : const SizedBox()
            ], //D88232FD
          ),
        ));
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
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;
      postEnd = await model.getPost(restart: restart, postIndex: _postIndex);
    }
  }
}
