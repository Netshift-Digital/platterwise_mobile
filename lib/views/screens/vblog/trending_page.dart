import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class TrendingPage extends StatefulWidget {
  final String basedOn;
  const TrendingPage({Key? key, required this.basedOn}) : super(key: key);

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  bool loading = false;
  final ScrollController scrollController = ScrollController();
  int _postIndex = 0;
  bool postEnd = false;
  List<Post>? trendingPost;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: trendingPost == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.p200),
              ),
            )
          : trendingPost!.isEmpty
              ? const Center(child: EmptyContentContainer())
              : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: trendingPost!.length,
                      itemBuilder: (context, index) {
                        var data = trendingPost![index];
                        return TimelinePostContainer(data);
                      }),
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (widget.basedOn == "baselike") {
          setBasedOnLikes(restart: false);
        } else {
          setBasedOnComment(restart: false);
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      if (widget.basedOn == "baselike") {
        setBasedOnLikes(restart: true);
      } else {
        setBasedOnComment(restart: true);
      }
    });
  }

  setBasedOnLikes({bool restart = false}) {
    if (restart) {
      _postIndex = 0;
      trendingPost = [];
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;
      var model = context.read<VBlogViewModel>();
      model.getTrendingLikes(_postIndex).then((value) {
        if (value != null) {
          setState(() {
            trendingPost?.addAll(value);
          });
          if (value.isEmpty || value.length < 30) {
            postEnd = true;
          }
        }
      });
    }
  }

  setBasedOnComment({bool restart = false}) {
    if (restart) {
      _postIndex = 0;
      trendingPost = [];
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;

      var model = context.read<VBlogViewModel>();
      model.getTrendingOnComment(_postIndex).then((value) {
        if (value != null) {
          setState(() {
            trendingPost?.addAll(value);
          });
          if (value.isEmpty || value.length < 30) {
            postEnd = true;
          }
        }
      });
    }
  }
}
