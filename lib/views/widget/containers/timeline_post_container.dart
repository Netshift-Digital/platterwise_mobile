import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_text/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:like_button/like_button.dart';
import 'package:platterwave/constant/post_type.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/dynamic_link.dart';
import 'package:platterwave/utils/matcher.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/utils/text_validation.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/screens/vblog/post_by_tag.dart';
import 'package:platterwave/views/screens/vblog/post_details.dart';
import 'package:platterwave/views/screens/vblog/post_like.dart';
import 'package:platterwave/views/screens/vblog/report_screen.dart';
import 'package:platterwave/views/screens/vblog/video_player.dart';
import 'package:platterwave/views/widget/containers/image_staggered.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/dialog/alert_dialog.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

var vidImage =
    "https://www.balmoraltanks.com/images/common/video-icon-image.jpg";
List likes = [];

class TimelinePostContainer extends StatefulWidget {
  final Post post;
  final bool tap;
  const TimelinePostContainer(this.post, {this.tap = true, Key? key})
      : super(key: key);

  @override
  State<TimelinePostContainer> createState() => _TimelinePostContainerState();
}

class _TimelinePostContainerState extends State<TimelinePostContainer> {
  int like = 0;
  @override
  Widget build(BuildContext context) {
    var blogModel = context.watch<VBlogViewModel>();
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        if (widget.tap) {
          nav(context, PostDetails(post: widget.post));
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 28.h,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    nav(
                      context,
                      ViewUserProfileScreen(
                        id: widget.post.userId.toString(),
                      ),
                    );
                  },
                  child: ImageCacheCircle(
                    widget.post.profileUrl,
                    height: 68,
                    width: 68,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        nav(
                          context,
                          ViewUserProfileScreen(
                            id: widget.post.userId.toString(),
                          ),
                        );
                      },
                      child: Text(
                        widget.post.fullName,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.h3.copyWith(
                            fontSize:
                                widget.post.fullName.toString().length > 23
                                    ? 15
                                    : 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "@${widget.post.username}",
                          style: AppTextTheme.h6
                              .copyWith(fontSize: 12, color: AppColor.g600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          RandomFunction.timeAgo(
                              widget.post.timestamp.toString()),
                          style: AppTextTheme.h6.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColor.g600),
                        ),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                // SvgPicture.asset("assets/icon/option.svg"),
                PopupMenuButton<int>(
                  onSelected: (e) {
                    if (e == 1) {
                      nav(context,
                          ReportPost(postId: widget.post.postId.toString()));
                    } else if (e == 3) {
                      CustomAlert(
                          context: context,
                          title: "Delete post",
                          body: "Are you sure you want to delete this post",
                          onTap: () {
                            blogModel.deletePost(widget.post);
                          }).show();
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 0,
                      onTap: () {
                        context.read<VBlogViewModel>().savePost(widget.post);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Saved"),
                        ));
                      },
                      // row has two child icon and text
                      child: const Row(
                        children: [
                          Icon(Icons.bookmark),
                          SizedBox(
                            // sized box with width 10
                            width: 10,
                          ),
                          Text("Save")
                        ],
                      ),
                    ),
                    LocalStorage.getUserId() == widget.post.userId.toString()
                        ? PopupMenuItem(
                            value: 3,
                            onTap: () {},
                            // row has two child icon and text
                            child: const Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(
                                  // sized box with width 10
                                  width: 10,
                                ),
                                Text("Delete post")
                              ],
                            ),
                          )
                        : PopupMenuItem(
                            value: 1,
                            onTap: () {
                              //Report post
                            },
                            // row has two child icon and text
                            child: Row(
                              children: const [
                                Icon(Icons.flag),
                                SizedBox(
                                  // sized box with width 10
                                  width: 10,
                                ),
                                Text("Report Post")
                              ],
                            ),
                          ),
                  ],
                  // offset:const Offset(0, 100),
                  // color: Colors.grey,
                  elevation: 2,
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            CustomText(
              widget.post.contentPost,
              matchStyle: AppTextTheme.h3.copyWith(
                color: AppColor.p200,
                fontWeight: FontWeight.w500,
              ),
              style: AppTextTheme.h3,
              onTap: (text) {
                nav(context, PostByTag(tag: text.toString()));
              },
              definitions: const [
                TextDefinition(matcher: UrlMatcher()),
                TextDefinition(matcher: EmailMatcher()),
                TextDefinition(matcher: HashTagMatcher()),
              ],
            ),
            SizedBox(
              height: 11.h,
            ),
            widget.post.contentType == PostType.text
                ? const SizedBox()
                : widget.post.contentType == PostType.image
                    ? imageWid(context)
                    : videoWid(),

            // Container(
            //   height: 239.h,
            //   width: 343.w,
            //   decoration: BoxDecoration(
            //       color: AppColor.p300,
            //       borderRadius: BorderRadius.circular(15),
            //       shape: BoxShape.rectangle),
            //   child: const ImageCacheR(
            //     "https://www.balmoraltanks.com/images/common/video-icon-image.jpg",
            //   ),
            // )
            SizedBox(
              height: 18.h,
            ),
            Row(
              children: [
                CustomAppIcon(
                  icon: "assets/icon/like.svg",
                  like: LikeButton(
                    isLiked: widget.post.liked.isNotEmpty,
                    onTap: (v) async {
                      if (blogModel.checkIsLiked(widget.post.postId) == false) {
                        blogModel.likePost(
                            widget.post, context.read<UserViewModel>().user!);
                        setState(() {
                          widget.post.likeCount = widget.post.likeCount + 1;
                          widget.post.liked = ['yes'];
                        });
                      } else {}
                      setState(() {});
                      return null;
                    },
                  ),
                  onTextTap: () {
                    RandomFunction.sheet(
                        context,
                        PostLike(
                          post: widget.post,
                        ));
                  },
                  count: widget.post.likeCount.toString(),
                ),
                const Spacer(
                  flex: 1,
                ),
                CustomAppIcon(
                  onTap: () {
                    if (widget.tap) {
                      nav(context, PostDetails(post: widget.post));
                    }
                  },
                  icon: "assets/icon/comment.svg",
                  count: widget.post.commentCount.toString(),
                ),
                const Spacer(
                  flex: 1,
                ),
                CustomAppIcon(
                  onTap: () {
                    DynamicLink.createLink(widget.post).then((value) {
                      if (value != null) {
                        Share.share(value);
                      }
                    });
                  },
                  icon: "assets/icon/share.svg",
                  count: "",
                ),
                const Spacer(
                  flex: 3,
                )
              ],
            ),
            SizedBox(
              height: 18.h,
            ),
            const Divider(
              color: AppColor.g50,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }

  // Widget videoWid() {
  //   return GestureDetector(
  //     onTap: () {
  //       nav(
  //           context,
  //           VideoPlay(
  //             url: widget.post.contentUrl,
  //           ));
  //     },
  //     child: Container(
  //       height: 239.h,
  //       width: double.maxFinite,
  //       decoration: BoxDecoration(
  //           color: Colors.black,
  //           borderRadius: BorderRadius.circular(15),
  //           shape: BoxShape.rectangle),
  //       child: Stack(
  //         children: [
  //           TextValidator.isValidUrl(widget.post.contentType)
  //               ? ImageCacheR(
  //                   widget.post.contentType,
  //                   fit: true,
  //                   blend: 0.5,
  //                 )
  //               : const ImageCacheR(
  //                   "https://www.balmoraltanks.com/images/common/video-icon-image.jpg",
  //                 ),
  //           TextValidator.isValidUrl(widget.post.contentType)
  //               ? SizedBox(
  //                   height: 239.h,
  //                   width: 343.w,
  //                   child: Center(
  //                       child:
  //                           SvgPicture.asset("assets/images/play-circle.svg")))
  //               : const SizedBox()
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget videoWid() {
    return GestureDetector(
      onTap: () {
        nav(
            context,
            VideoPlay(
              url: widget.post.contentUrl,
            ));
      },
      child: Container(
        height: 239.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle),
        child: Stack(
          children: [
            TextValidator.isValidUrl(widget.post.contentType)
                ? ImageCacheR(
                    widget.post.contentType,
                    fit: true,
                    blend: 0.5,
                    chachedImage: true,
                  )
                : const ImageCacheR(
                    "https://www.balmoraltanks.com/images/common/video-icon-image.jpg",
                    chachedImage: true,
                  ),
            TextValidator.isValidUrl(widget.post.contentType)
                ? SizedBox(
                    height: 239.h,
                    width: 343.w,
                    child: Center(
                        child:
                            SvgPicture.asset("assets/images/play-circle.svg")))
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      like = widget.post.likeCount;
    });
  }

  String showHashtag(e) {
    if (e.toString().startsWith("#")) {
      return "";
    } else {
      return "#";
    }
  }

  Widget imageWid(BuildContext context) {
    var data = widget.post.contentUrl.replaceAll(']', '').split('  ,');
    if (data.length > 1) {
      return ImageStag(images: data);
    }
    return GestureDetector(
      onTap: () {
        showImageViewer(
            context, CachedNetworkImageProvider(widget.post.contentUrl),
            onViewerDismissed: () {},
            useSafeArea: true,
            swipeDismissible: true);
      },
      child: Container(
        height: 239.h,
        width: 343.w,
        decoration: BoxDecoration(
            //  color: AppColor.p300,
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle),
        child: ImageCacheR(
          widget.post.contentUrl,
          chachedImage: true,
        ),
      ),
    );
  }
}
