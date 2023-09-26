import 'package:flutter/material.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';

class RecommendedTab extends StatefulWidget {
  const RecommendedTab({super.key});

  @override
  State<RecommendedTab> createState() => _RecommendedTabState();
}

class _RecommendedTabState extends State<RecommendedTab> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var model = context.read<VBlogViewModel>();
    return SingleChildScrollView(
      //physics: const BouncingScrollPhysics(),
      controller: scrollController,
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         height: 10.h,
          //       ),
          //       PlatButton(
          //           title: "Trending",
          //           height: 39,
          //           width: 84,
          //           textSize: 15,
          //           padding: 4,
          //           textColor: AppColor.g800,
          //           color: AppColor.g30,
          //           onTap: () {}),
          //       SizedBox(
          //         height: 20.h,
          //       ),
          //       Row(
          //         children: [
          //           SubCategoriesContainer(
          //             onTap: () {
          //               nav(context,
          //                   const TrendingPage(basedOn: 'baselike'));
          //             },
          //             title: 'Most Liked',
          //             image: "assets/images/likes.png",
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           SubCategoriesContainer(
          //             onTap: () {
          //               nav(context,
          //                   const TrendingPage(basedOn: 'basecomment'));
          //             },
          //             title: 'Most Commented ',
          //             image: "assets/images/comments.png",
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 20.h,
          //       ),
          //     ],
          //   ),
          // ),
          Consumer<VBlogViewModel>(
            builder: (context, vBlogModel, child) {
              final posts = vBlogModel.posts;
              return ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var data = posts[index];
                  print("Here are the posts $posts");
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
    );
  }
}
