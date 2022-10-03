import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/vblog/popular_page.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/appbar/appbar_platterwise.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:platterwave/views/widget/text_feild/text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchTextController = TextEditingController();
    SizeConfig.init(context);
    return Scaffold(
      appBar:const PlatterwiseAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 32.h,),
              AppTextField(
                fillColor: AppColor.g30,
                isSearch: true,
                hasBorder: false,
                controller: searchTextController,
                hintText: "Search for a post or people",
                prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
              ),
              SizedBox(height: 24.h,),
              DefaultTabController(
                initialIndex: 1,
                  length: 2,
                  child: Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 120.w),
                          child: TabBar(
                            tabs: const [
                              Tab(text: "Trending",),
                              Tab(text: "Popular",)
                            ],
                            // padding: EdgeInsets.only(right: 100.w),
                            labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                            unselectedLabelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                            labelColor: AppColor.textColor,
                            unselectedLabelColor: AppColor.g60,
                            indicatorColor: AppColor.p300,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 1.w,
                            indicatorPadding: EdgeInsets.symmetric(horizontal: 15.w),

                          ),
                        ),
                       const Expanded(
                            child: TabBarView(
                              children: [
                                TrendingPage(),
                                PopularPage(),
                              ],)
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
