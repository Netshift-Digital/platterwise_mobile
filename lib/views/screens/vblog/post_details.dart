import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/dynamic_link.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/screens/vblog/comment_replies.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PostDetails extends StatefulWidget {
  final Post post;
  const PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<UsersComment> comments = [];
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = context.read<UserViewModel>().user;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: kOverlay,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 15),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimelinePostContainer(
                      widget.post,
                      tap: false,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Column(
                      children: [
                        Text(
                          "Comments (${comments.length})",
                          style: AppTextTheme.h3.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          height: 1,
                          width: 32,
                          color: AppColor.p200,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    comments.isEmpty
                        ? const Center(
                            child: EmptyContentContainer(
                              errorText: "Be the first to comment",
                            ),
                          )
                        : ListView.builder(
                            itemCount: comments.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              UsersComment data = comments[index];
                              return GestureDetector(
                                onTap: () {
                                  nav(
                                      context,
                                      CommentReply(
                                          usersComment: data,
                                          post: widget.post));
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (data.firebaseAuthID
                                                  .toString()
                                                  .isNotEmpty) {
                                                nav(
                                                    context,
                                                    ViewUserProfileScreen(
                                                      id: data.firebaseAuthID,
                                                    ));
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(34),
                                              child: ImageCacheR(
                                                data.profileUrl,
                                                height: 35,
                                                width: 35,
                                                chachedImage: true,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.fullName,
                                                style: AppTextTheme.h3.copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "@${data.username}",
                                                    style: AppTextTheme.h6
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color:
                                                                AppColor.g600),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    RandomFunction.timeAgo(data
                                                        .timestamp
                                                        .toString()),
                                                    style: AppTextTheme.h4
                                                        .copyWith(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          //SvgPicture.asset("assets/icon/option.svg")
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Replying to ",
                                            style: AppTextTheme.h4.copyWith(
                                                fontSize: 14,
                                                color: AppColor.g900,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "@${widget.post.username}",
                                            style: AppTextTheme.h4.copyWith(
                                                fontSize: 14,
                                                color: AppColor.p200,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        data.comment,
                                        style: AppTextTheme.h4.copyWith(
                                            fontSize: 16,
                                            color: AppColor.g900,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Row(
                                        children: [
                                          CustomAppIcon(
                                            onTap: () {
                                              nav(
                                                  context,
                                                  CommentReply(
                                                      usersComment: data,
                                                      post: widget.post));
                                            },
                                            icon: "assets/icon/comment.svg",
                                            count: data.commentReply,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          CustomAppIcon(
                                            onTap: () {
                                              DynamicLink.createLink(
                                                      widget.post)
                                                  .then((value) {
                                                if (value != null) {
                                                  Share.share(value);
                                                }
                                              });
                                            },
                                            icon: "assets/icon/share.svg",
                                            count: "",
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      const Divider(
                                        color: AppColor.g50,
                                        thickness: 0.5,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: PhysicalModel(
                color: Colors.black,
                elevation: 10,
                child: Container(
                  height: 125,
                  width: size.width,
                  color: Colors.white,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 30),
                      child: Row(
                        children: [
                          ImageCacheCircle(
                            user == null ? "" : user.profileUrl,
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: TextField(
                            controller: commentController,
                            onSubmitted: (e) {
                              if (e.isNotEmpty) {
                                postComment(e);
                              }
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add a comment ",
                                filled: true,
                                fillColor: AppColor.g30),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getComment();
    Future.delayed(const Duration(milliseconds: 40), () {
      getComment();
    });
  }

  void getComment() {
    var model = context.read<VBlogViewModel>();
    model.getComment(widget.post.postId).then((value) {
      if (mounted) {
        setState(() {
          comments = value;
        });
      }
    });
  }

  void postComment(String e) {
    commentController.clear();
    var model = context.read<VBlogViewModel>();
    var uid = context.read<UserViewModel>().user!.userId;
    model
        .commentOnPost(
      widget.post.postId,
      uid.toString(),
      e,
      userData: context.read<UserViewModel>().user!,
      id: widget.post.userId.toString(),
    )
        .then((value) {
      getComment();
      if (value != null) {
        widget.post.commentCount = widget.post.commentCount + 1;
        setState(() {});
      }
    });
  }
}
