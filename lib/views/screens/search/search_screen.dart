import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:platterwave/views/widget/tiles/activity/comment_on_post.dart';

import '../../../res/color.dart';
import '../../widget/appbar/appbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            AppTextField(
              fillColor: AppColor.g30,
              isSearch: true,
              hintText: "Search for a post or people",
                prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
              suffixIcon: SvgPicture.asset("assets/icon/cancel.svg"),
            ),
          ],
        ),
      ),
    );
  }

}
