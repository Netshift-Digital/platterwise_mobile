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
  List<Post>? trendingPost;
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
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
                      itemCount: trendingPost!.length,
                      itemBuilder: (context, index) {
                        var data = trendingPost![index];
                        return TimelinePostContainer(data);
                      }),
                ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (widget.basedOn == "baselike") {
        setBasedOnLikes();
      } else {
        setBasedOnComment();
      }
    });
  }

  setBasedOnLikes() {
    var model = context.read<VBlogViewModel>();
    model.getTrendingLikes().then((value) {
      if (value != null) {
        trendingPost = value;
      }
      setState(() {});
    });
  }

  setBasedOnComment() {
    var model = context.read<VBlogViewModel>();
    model.getTrendingOnComment().then((value) {
      if (value != null) {
        trendingPost = value;
      }
      setState(() {});
    });
  }

  stop() {
    setState(() {
      loading = false;
    });
  }

  start() {
    setState(() {
      loading = true;
    });
  }
}
