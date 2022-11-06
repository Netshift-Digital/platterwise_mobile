import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/notification.dart';
import 'package:platterwave/views/screens/vblog/popular_page.dart';
import 'package:platterwave/views/screens/vblog/create_post/create_post.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.p300,
          child: SvgPicture.asset('assets/icon/post.svg'),
        onPressed: (){
        nav(context, const CreatePost());
         // FirebaseAuth.instance.signOut();
        },
      ),
      body: AnnotatedRegion(
        value: kOverlay,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 15),
            child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                  headerSliverBuilder:(context,scroll){
                   return[
                     SliverAppBar(
                       elevation: 0,
                       centerTitle: false,
                       backgroundColor: Colors.white,
                       pinned: false,
                       actions: [
                         GestureDetector(
                           onTap: (){
                             nav(context, const NotificationActivity());
                           },
                             child: SvgPicture.asset("assets/icon/notification-bing.svg"))
                       ],
                       title: ConstrainedBox(
                           constraints: const BoxConstraints(maxHeight: 28, maxWidth: 300),
                           child: SvgPicture.asset(
                             "assets/icon/platterwise_logo.svg",
                             height: 15.h,
                             width: 161.w,
                           )
                       ),
                       // flexibleSpace:  Column(
                       //   mainAxisAlignment: MainAxisAlignment.end,
                       //   crossAxisAlignment: CrossAxisAlignment.start,
                       //   children: [
                       //     SizedBox(height: 10.h,),
                       //     // AppTextField(
                       //     //   fillColor: AppColor.g30,
                       //     //   isSearch: true,
                       //     //   hasBorder: false,
                       //     //   controller: searchTextController,
                       //     //   hintText: "Search for a post or people",
                       //     //   prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
                       //     // ),
                       //   //  SizedBox(height: 10.h,),
                       //   ],
                       // ),
                       //collapsedHeight:140 ,
                     ),
                     SliverAppBar(
                       backgroundColor:AppColor.g0,
                       elevation: 0.0,
                       pinned: true,
                       toolbarHeight: 60,
                       //collapsedHeight: 0,
                       expandedHeight: 0,
                       primary: false,
                       automaticallyImplyLeading: false,
                       title: Column(
                         children: [
                           TabBar(
                             tabs: const [
                               Tab(text: "Trending",),
                               Tab(text: "Popular",)
                             ],
                              padding: EdgeInsets.only(right: 100.w),
                             labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                             unselectedLabelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                             labelColor: AppColor.textColor,
                             unselectedLabelColor: AppColor.g60,
                             indicatorColor: AppColor.p300,
                             indicatorSize: TabBarIndicatorSize.label,
                             indicatorWeight: 1.w,
                             indicatorPadding: EdgeInsets.symmetric(horizontal: 15.w),

                           ),
                         ],
                       ),
                     )
                   ];
                },
                  body: const TabBarView(
                    children: [
                      TrendingPage(),
                      PopularPage(),
                    ],)
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPost();
  }

  void getPost() {
    var model = context.read<VBlogViewModel>();
    model.getPost();
  }
}
