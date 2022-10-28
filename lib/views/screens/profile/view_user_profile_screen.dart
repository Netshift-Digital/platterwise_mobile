import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/profile/settings_screen.dart';
import 'package:platterwave/views/screens/profile/view_likes_page.dart';
import 'package:platterwave/views/screens/profile/view_posts_page.dart';
import 'package:platterwave/views/widget/appbar/custom_app_bar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

import '../../../utils/nav.dart';
import '../../widget/tiles/settings_tile.dart';
import '../vblog/create_post/create_post.dart';
import 'edit_profile_screen.dart';

class ViewUserProfileScreen extends StatefulWidget {
  final String? id;
  const ViewUserProfileScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ViewUserProfileScreen> createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  var user = FirebaseAuth.instance.currentUser!;
  List<Post> myPost =  [];
  UserData? userData;
  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserViewModel>();
    var blogModel = context.watch<VBlogViewModel>();
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
      body: userData==null?const Center(child: CircularProgressIndicator())
          :Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ImageCacheCircle(
                        userData!.userProfile.profileUrl,
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData!.userProfile.username,style: AppTextTheme.h1,),
                          SizedBox(height: 4.h,),
                          Text(userData!.userProfile.fullName, style: AppTextTheme.h4,)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 30.h,),
                  Text(userData!.userProfile.bio, style: AppTextTheme.h3,),
                  SizedBox(height: 30.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream:FirebaseFirestore.instance.collection("following").
                            doc("users").collection(widget.id??FirebaseAuth.instance.currentUser!.uid).snapshots(),
                            builder: (context, snapshot) {

                              return Text(snapshot.hasData?snapshot.data!.docs.length.toString():
                              "0", style: AppTextTheme.h3,);
                            }
                          ),
                          Text(
                            "Following",
                            style: AppTextTheme.h4.copyWith(
                                color: AppColor.g300),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream:FirebaseFirestore.instance.collection("followers").
                              doc("users").collection(widget.id??FirebaseAuth.instance.currentUser!.uid).snapshots(),
                              builder: (context, snapshot) {

                                return Text(snapshot.hasData?snapshot.data!.docs.length.toString():
                                "0", style: AppTextTheme.h3,);
                              }
                          ),
                          Text(
                            "Followers",
                            style: AppTextTheme.h4.copyWith(
                              color: AppColor.g300),)
                        ],
                      ),
                      widget.id!=null?PlatButton(
                        title: blogModel.getIsFollowed(userData!.userProfile.email)?"Unfollow":"Follow",
                        padding: 0,
                        textSize: 14,
                        onTap: (){
                          //blogModel.following.add(userData!.userProfile);
                          if(blogModel.getIsFollowed(userData!.userProfile.email)){
                            blogModel.unFollowUser(widget.id!, userData!.userProfile);
                          }else{
                           blogModel.followUser(widget.id!, userData!.userProfile);

                          }
                        },
                        width: 95.w,
                        height: 38.h,
                      ) : PlatButton(
                        title: "Edit Profile",
                        padding: 0,
                        textSize: 14,
                        onTap: (){
                          settings(context);
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
                            ViewPostsPage(post: myPost,),
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
       onPressed: (){
         getPost();
       },
     ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 20),(){
      getData();
      getPost();
    });
  }

  void getData() async{
    var userModel = context.read<UserViewModel>();
    var blogModel = context.read<VBlogViewModel>();
    if(widget.id==null){
      if(userModel.user!=null){
        userData=userModel.user;
      }else{
        userModel.getMyProfile().then((value){
          setState(() {
            userData=value;
          });
        });
      }
    }else{
      userModel.getUserProfile(widget.id!).then((value){
        if(value!=null){
          setState(() {
            userData=value;
          });
        }
      });
    }

    // await blogModel.getFollowers();
    // await  blogModel.getFollowing();
  }

  void getPost() {
    var blogModel = context.read<VBlogViewModel>();
    if(widget.id==null){
      if(blogModel.myPosts.isEmpty){
        blogModel.getMyPost().then((value){
          if(value!=null){
            myPost=value;
          }
        });
      }
    }else{
      blogModel.getUserPost(widget.id!).then((value){
        if(value!=null){
          myPost=value;
        }
      });
    }

  }

  void settings(BuildContext context) async{
    var userModel = context.read<UserViewModel>();
   await Navigator.push(
        context, MaterialPageRoute(builder: (context){
      return EditProfileScreen(userData: userData!,);
    })
    );
   userModel.getMyProfile().then((value){
     setState(() {
       userData=value;
     });
   });

  }
}
