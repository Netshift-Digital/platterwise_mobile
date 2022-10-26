import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/profile/settings_screen.dart';
import 'package:platterwave/views/screens/profile/view_likes_page.dart';
import 'package:platterwave/views/screens/profile/view_posts_page.dart';
import 'package:platterwave/views/widget/appbar/custom_app_bar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';

import '../../../utils/nav.dart';
import '../../widget/tiles/settings_tile.dart';
import '../vblog/create_post/create_post.dart';
import 'edit_profile_screen.dart';

class ViewUserProfileScreen extends StatefulWidget {
  const ViewUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewUserProfileScreen> createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  var user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: CustomAppBar(
        onTap: (){
          showBottomSheet(
              context: context,
              enableDrag: true,
              builder: (context){
                return Container(
                  height: 350.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),

                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 18.h,),
                        Divider(
                          thickness: 2,
                          indent: 150,
                          endIndent: 150,
                        ),
                        SettingsTile(
                          title: "Settings",
                          leading: "assets/icon/settings.svg",
                          onTap: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context){
                              return SettingsScreen();
                            })
                            );
                          },
                        ),
                        SizedBox(height: 25.h,),
                        SettingsTile(
                          title: "Content and Privacy Policy",
                          leading: "assets/icon/note-text.svg",
                          onTap: () {},
                        ),
                        SizedBox(height: 25.h,),
                        SettingsTile(
                          title: "Help Center",
                          leading: "assets/icon/help-center-icon.svg",
                          onTap: () {},
                        ),
                        SizedBox(height: 45.h,),
                        SettingsTile(
                          title: "Logout",
                          leading: "assets/icon/logout.svg",
                          onTap: () {
                            nav(context, Login());
                            Future.delayed(const Duration(milliseconds: 500),(){
                              FirebaseAuth.instance.signOut();
                            });

                          },
                        ),
                      ],
                    ),
                  ),
                );
          }
          );
        },
        trailing: "assets/icon/option.svg",
      ),
      body: Column(
        children: [
          Container(
            color: AppColor.g20,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 88.h,
                        width: 88.w,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.p300,
                          image: DecorationImage(
                        image: NetworkImage("https://thumbs.dreamstime.com/b/lonely-elephant-against-sunset-beautiful-sun-clouds-savannah-serengeti-national-park-africa-tanzania-artistic-imag-image-106950644.jpg"),
                       fit: BoxFit.cover)
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName??"Eti chisom",style: AppTextTheme.h1,),
                          SizedBox(height: 4.h,),
                          Text(user.email??"")
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 30.h,),
                 const Text("i am a mobile developer"),
                  SizedBox(height: 30.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("0"),
                          Text("Following")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("0"),
                          Text("Followers")
                        ],
                      ),
                      PlatButton(
                        title: "Edit Profile",
                        padding: 0,
                        textSize: 14,
                        onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context){
                            return EditProfileScreen();
                          })
                          );
                        },
                        width: 95.w,
                        height: 38.h,
                      )
                    ],
                  ),
                  SizedBox(height: 30.h,),
                ],
              ),
            ),
          ),
          DefaultTabController(
              initialIndex: 1,
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: TabBar(
                        tabs: const [
                          Tab(text: "Posts",),
                          Tab(text: "Likes",)
                        ],
                        // padding: EdgeInsets.only(right: 100.w),
                        labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                        unselectedLabelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                        labelColor: AppColor.textColor,
                        unselectedLabelColor: AppColor.g60,
                        indicatorColor: AppColor.p300,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1.w,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 7.w),

                      ),
                    ),
                    Expanded(
                        child: TabBarView(
                          children: [
                            ViewPostsPage(),
                            ViewLikesPage(),
                          ],)
                    )
                  ],
                ),
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.p300,
        child: SvgPicture.asset('assets/icon/post.svg'),
        onPressed: (){
          nav(context, const CreatePost());
        },
      ),
    );
  }
}
