import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/search/search_screen.dart';
import 'package:platterwave/views/screens/vblog/create_post/create_post.dart';
import 'package:platterwave/views/screens/vblog/following_tab.dart';
import 'package:platterwave/views/screens/vblog/notification.dart';
import 'package:platterwave/views/screens/vblog/recommended_tab.dart';

// ignore: must_be_immutable
class Timeline extends StatelessWidget {
  Timeline({Key? key}) : super(key: key);

  bool hideFab = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.p300,
        child: SvgPicture.asset('assets/icon/post.svg'),
        onPressed: () {
          nav(context, const CreatePost());
        },
      ),
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: kOverlay,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 28, maxWidth: 300),
            child: const Text(
              'Community',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFCCCCCC)),
            )),
        // SvgPicture.asset(
        //   "assets/icon/platterwise_logo.svg",
        //   height: 15.h,
        //   width: 161.w,
        // )),
        actions: [
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              nav(context, const SearchScreen());
            },
            child: SvgPicture.asset('assets/icon/search-normal.svg'),
          ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
              onTap: () {
                nav(context, const NotificationActivity());
              },
              child: SvgPicture.asset("assets/icon/notification-bing.svg")),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          //  controller: scrollController,
          headerSliverBuilder: (context, scroll) {
            return [
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 10,
              )),
              SliverAppBar(
                backgroundColor: AppColor.g0,
                elevation: 0.0,
                pinned: true,
                toolbarHeight: 60,
                //collapsedHeight: 0,
                expandedHeight: 0,
                primary: false,
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: TabBar(
                        tabs: const [
                          Tab(
                            text: "Following",
                          ),
                          Tab(
                            text: "Recommended",
                          )
                        ],
                        // padding: EdgeInsets.only(right: 100.w),
                        labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                        unselectedLabelStyle:
                            AppTextTheme.h6.copyWith(fontSize: 18),
                        labelColor: AppColor.textColor,
                        unselectedLabelColor: AppColor.g60,
                        indicatorColor: AppColor.p300,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1.w,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 7.w),
                      ),
                    )
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [FollowingTab(), RecommendedTab()],
          ),
        ),
      ),
    );
  }
}
