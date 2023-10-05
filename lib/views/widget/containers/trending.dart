import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
// import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';

class Trending extends StatelessWidget {
  final String? errorText;
  const Trending({Key? key, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                PlatButton(
                    title: "Trending",
                    height: 39,
                    width: 84,
                    textSize: 15,
                    padding: 4,
                    textColor: AppColor.g800,
                    color: AppColor.g30,
                    onTap: () {}),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubCategoriesContainer(
                      onTap: () {
                        nav(context, const TrendingPage(basedOn: 'baselike'));
                      },
                      title: 'Most Liked',
                      image: "assets/images/likes.png",
                    ),
                    SubCategoriesContainer(
                      onTap: () {
                        nav(context,
                            const TrendingPage(basedOn: 'basecomment'));
                      },
                      title: 'Most Commented ',
                      image: "assets/images/comments.png",
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
