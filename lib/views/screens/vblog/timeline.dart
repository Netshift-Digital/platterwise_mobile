import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/dynamic_link.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/notification.dart';
import 'package:platterwave/views/screens/vblog/popular_page.dart';
import 'package:platterwave/views/screens/vblog/create_post/create_post.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
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
    var model = context.read<VBlogViewModel>();
    SizeConfig.init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.p300,
          child: SvgPicture.asset('assets/icon/post.svg'),
        onPressed: (){
          nav(context, const CreatePost());
         //FirebaseAuth.instance.signOut();
         //  var s = "chisom is a good boy ";
         //  var d = s.split(" ");
         //  print(d);
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
                       flexibleSpace:  Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           SizedBox(height: 10.h,),
                           PlatButton(
                               title: "Trending",
                               height: 39,
                               width: 84,
                               textSize: 15,
                               padding: 4,
                               textColor: AppColor.g800,
                               color:AppColor.g30 ,
                               onTap: (){

                               }
                           ),
                           SizedBox(height: 20.h,),
                           SingleChildScrollView(
                             physics: const BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             child: Row(
                               children: [
                                 SubCategoriesContainer(
                                   onTap: (){
                                     nav(context, const TrendingPage(basedOn: 'baselike'));
                                   },
                                   title: 'Most Liked',
                                 ),
                                const  SizedBox(width:12 ,),
                                 SubCategoriesContainer(
                                   onTap: (){
                                     nav(context, const TrendingPage(basedOn: 'basecomment'));
                                   },
                                   title: 'Most Commented ',
                                 )
                               ],
                             ),
                           ),
                           SizedBox(height: 20.h,),

                         ],
                       ),
                       collapsedHeight:260 ,
                     ),
                     // SliverAppBar(
                     //   backgroundColor:AppColor.g0,
                     //   elevation: 0.0,
                     //   pinned: true,
                     //   toolbarHeight: 60,
                     //   //collapsedHeight: 0,
                     //   expandedHeight: 0,
                     //   primary: false,
                     //   automaticallyImplyLeading: false,
                     //   title: Column(
                     //     children: [
                     //       TabBar(
                     //         tabs: const [
                     //           Tab(text: "Trending",),
                     //           Tab(text: "Popular",)
                     //         ],
                     //          padding: EdgeInsets.only(right: 100.w),
                     //         labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                     //         unselectedLabelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                     //         labelColor: AppColor.textColor,
                     //         unselectedLabelColor: AppColor.g60,
                     //         indicatorColor: AppColor.p300,
                     //         indicatorSize: TabBarIndicatorSize.label,
                     //         indicatorWeight: 1.w,
                     //         indicatorPadding: EdgeInsets.symmetric(horizontal: 15.w),
                     //
                     //       ),
                     //     ],
                     //   ),
                     // )
                   ];
                },
                  body: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.watch<VBlogViewModel>().posts.length,
                      itemBuilder: (context,index) {
                        var data =  model.posts[index];
                        return  TimelinePostContainer(data);
                      }
                  )
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
    model.getTrending();
  }
}
