import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/search/search_screen.dart';
import 'package:platterwave/views/screens/vblog/post_by_tag.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';

class TopTags extends StatelessWidget {
  const TopTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var blogModel = context.watch<VBlogViewModel>();
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              enabled: false,
              fillColor: AppColor.g30,
              isSearch: true,
              hasBorder: false,
              onTap: (){
                nav(context, const SearchScreen());
              },
              hintText: "Search for a post or people",
              prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
            ),
            SizedBox(height: 35.h,),
            Text("Trends for you",
                style: AppTextTheme.h1
            ),
            SizedBox(height: 15.h,),
            Expanded(
              child: ListView.builder(
                  itemCount:blogModel.topTags.length ,
                  itemBuilder: (context,index){
                    var data = blogModel.topTags[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: (){

                          ///
                          nav(context, PostByTag(tag:data.tagRank));

                        },
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Text(data.tagRank,
                          style: AppTextTheme.h3.copyWith(
                            fontWeight: FontWeight.w600
                          )),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
