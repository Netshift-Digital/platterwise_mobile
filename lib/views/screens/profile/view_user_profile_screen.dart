import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/profile/followers_list.dart';
import 'package:platterwave/views/screens/profile/settings_screen.dart';
import 'package:platterwave/views/screens/profile/view_likes_page.dart';
import 'package:platterwave/views/screens/profile/view_posts_page.dart';
import 'package:platterwave/views/screens/save/save_screen.dart';
import 'package:platterwave/views/widget/appbar/custom_app_bar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/nav.dart';
import '../../widget/dialog/alert_dialog.dart';
import '../../widget/tiles/settings_tile.dart';
import 'edit_profile_screen.dart';

class ViewUserProfileScreen extends StatefulWidget {
  String? id;
  UserProfile? userData;

  ViewUserProfileScreen({Key? key, this.id, this.userData}) : super(key: key);

  @override
  State<ViewUserProfileScreen> createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  var isFollowing = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: CustomAppBar(
        showMenuB: widget.id == LocalStorage.getUserId(),
        onTap: () {
          showModalBottomSheet(
              context: context,
              enableDrag: true,
              builder: (context) {
                return Container(
                  height: 350.h,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 18.h,
                            ),
                            const Divider(
                              thickness: 2,
                              indent: 150,
                              endIndent: 150,
                            ),
                            SettingsTile(
                              title: "Settings",
                              leading: "assets/icon/settings.svg",
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SettingsScreen();
                                }));
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SettingsTile(
                              title: "Content and Privacy Policy",
                              leading: "assets/icon/note-text.svg",
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SettingsTile(
                              title: "Saved Post",
                              leading: "assets/icon/love.svg",
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SaveScreen();
                                }));
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SettingsTile(
                              title: "Help Center",
                              leading: "assets/icon/help-center-icon.svg",
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SettingsTile(
                              title: "Logout",
                              leading: "assets/icon/logout.svg",
                              onTap: () {
                                logout(context);
                              },
                            ),
                          ],
                        ),
                      )),
                );
              });
        },
        trailing: "assets/icon/option.svg",
      ),
      body: widget.userData == null
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColor.p300,
            ))
          : DefaultTabController(
              length: 2,
              child: NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  headerSliverBuilder: (context, scroll) {
                    return [
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showImageViewer(
                                            context,
                                            CachedNetworkImageProvider(
                                                widget.userData!.profileUrl),
                                            onViewerDismissed: () {},
                                            useSafeArea: true,
                                            swipeDismissible: true);
                                      },
                                      child: ImageCacheCircle(
                                        widget.userData!.profileUrl,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!.username,
                                          style: AppTextTheme.h1,
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          widget.userData!.fullName,
                                          style: AppTextTheme.h4,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                LinkifyText(
                                  widget.userData!.bio,
                                  textStyle: AppTextTheme.h3,
                                  linkStyle: AppTextTheme.h3.copyWith(
                                      color: Colors.blue[900],
                                      decoration: TextDecoration.underline),
                                  linkTypes: const [
                                    LinkType.url,
                                    LinkType.hashTag
                                  ],
                                  onTap: (link) {
                                    launchLink(link.value!);
                                  },
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        nav(
                                            context,
                                            FollowersList(
                                              index: 0,
                                              id: widget.id ??
                                                  LocalStorage.getUserId(),
                                            ));
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.userData!.following
                                                  .toString(),
                                              style: AppTextTheme.h3,
                                            ),
                                            Text(
                                              "Following",
                                              style: AppTextTheme.h4.copyWith(
                                                  color: AppColor.g300),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        nav(
                                            context,
                                            FollowersList(
                                              index: 1,
                                              id: widget.id ??
                                                  LocalStorage.getUserId(),
                                            ));
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.userData!.followers
                                                  .toString(),
                                              style: AppTextTheme.h3,
                                            ),
                                            Text(
                                              "Followers",
                                              style: AppTextTheme.h4.copyWith(
                                                  color: AppColor.g300),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    showFollow()
                                        ? StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('followButton')
                                                .doc(widget.id)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              bool disable = false;
                                              if (snapshot.data != null) {
                                                if (snapshot.data!.exists) {
                                                  var data = snapshot.data!
                                                      .data()! as Map;
                                                  disable = data['disable'];
                                                }
                                              }
                                              if (disable == false) {
                                                return PlatButton(
                                                  title: isFollowing
                                                      ? "Unfollow"
                                                      : "Follow",
                                                  padding: 0,
                                                  textSize: 14,
                                                  color: isFollowing
                                                      ? AppColor.g700
                                                      : AppColor.p200,
                                                  onTap: () {
                                                    var user = context
                                                        .read<UserViewModel>()
                                                        .user;
                                                    var blogModel = context
                                                        .read<VBlogViewModel>();
                                                    if (isFollowing) {
                                                      blogModel
                                                          .unFollowUser(
                                                              widget.id!)
                                                          .then((value) {
                                                        if (value) {
                                                          setState(() {
                                                            isFollowing = false;
                                                            widget.userData!
                                                                .followers -= 1;
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      blogModel
                                                          .followUser(
                                                              widget.id!,
                                                              user!,
                                                              widget.userData!)
                                                          .then((value) {
                                                        if (value) {
                                                          setState(() {
                                                            isFollowing = true;
                                                            widget.userData!
                                                                .followers += 1;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  },
                                                  width: 95.w,
                                                  height: 38.h,
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            })
                                        : PlatButton(
                                            title: "Edit Profile",
                                            padding: 0,
                                            textSize: 14,
                                            onTap: () {
                                              settings(context);
                                            },
                                            width: 95.w,
                                            height: 38.h,
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                    text: "Posts",
                                  ),
                                  Tab(
                                    text: "Likes",
                                  )
                                ],
                                labelStyle:
                                    AppTextTheme.h6.copyWith(fontSize: 18),
                                unselectedLabelStyle:
                                    AppTextTheme.h6.copyWith(fontSize: 18),
                                labelColor: AppColor.textColor,
                                unselectedLabelColor: AppColor.g60,
                                indicatorColor: AppColor.p300,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorWeight: 1.w,
                                indicatorPadding:
                                    EdgeInsets.symmetric(horizontal: 7.w),
                              ),
                            )
                          ],
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                    children: [
                      ViewPostsPage(
                        id: widget.id!,
                      ),
                      ViewLikesPage(
                        id: widget.id,
                      ),
                    ],
                  )),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 20), () {
      getData();
      checkIsFollowing();
    });
  }

  void logout(BuildContext context) {
    CustomAlert(
        context: context,
        title: "Confirm to Logout ",
        body: "Are you sure you want to Logout from Platterwise??.",
        onTap: () {
          context.read<UserViewModel>().logout().then((value) {
            if (value == true) {
              DefaultCacheManager().emptyCache();
              FirebaseMessaging.instance
                  .unsubscribeFromTopic(LocalStorage.getUserId());
              LocalStorage.clear();
              nav(context, Login(), remove: true);
            }
          });
        }).show();
  }

  void getData() async {
    var userModel = context.read<UserViewModel>();
    if (widget.id == null || widget.id == LocalStorage.getUserId()) {
      userModel.getMyProfile().then((value) {
        if (mounted) {
          setState(() {
            widget.userData = value;
            widget.id = value?.userId.toString();
            userModel.user = value;
          });
        }
      });
    } else {
      if (widget.userData == null) {
        userModel.getUserProfile(widget.id!).then((value) {
          if (value != null) {
            if (mounted) {
              setState(() {
                widget.userData = value;
                widget.id = value.userId.toString();
              });
            }
          }
        });
      } else {
        widget.id = widget.userData?.userId.toString();
      }
    }
  }

  void settings(BuildContext context) async {
    var userModel = context.read<UserViewModel>();
    var data =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditProfileScreen(
        userData: widget.userData!,
      );
    }));
    if (data != null) {
      userModel.getMyProfile().then((value) {
        if (mounted) {
          setState(() {
            widget.userData = value;
          });
        }
      });
    }
  }

  void launchLink(String link) async {
    if (!await launchUrl(Uri.parse(link))) {
      throw 'Could not launch $link';
    }
  }

  bool showFollow() {
    if (widget.id == LocalStorage.getUserId()) {
      return false;
    } else {
      return true;
    }
  }

  checkIsFollowing() async {
    var blogModel = context.read<VBlogViewModel>();
    if (widget.id != null) {
      isFollowing = await blogModel.getIsFollowed(widget.id!);
    }
  }
}
