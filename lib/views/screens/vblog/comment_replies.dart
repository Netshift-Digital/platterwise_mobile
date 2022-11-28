import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/comment_reply.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';
import 'package:provider/provider.dart';

class CommentReply extends StatefulWidget {
  final UsersComment usersComment;
  final Post post;
  const CommentReply({Key? key, required this.usersComment, required this.post}) : super(key: key);

  @override
  State<CommentReply> createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  List<UsersReply>? searchResult;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = context.read<UserViewModel>().user;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(left: twenty,right: twenty),
              child: searchResult==null?
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColor.p200),
                ),
              )
                  :
              SingleChildScrollView(
                child: Column(
                  children: [
                     topComment(widget.usersComment),
                    const SizedBox(height: 10,),
                    searchResult!.isEmpty?
                    const EmptyContentContainer()
                        :ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: searchResult!.length,
                        itemBuilder: (context,index) {
                          var data =  searchResult![index];
                          return  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(data.firebaseAuthID.toString().isNotEmpty){
                                        nav(context, ViewUserProfileScreen(
                                          id: data.firebaseAuthID,
                                        ));
                                      }

                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(34),
                                      child: ImageCacheR(
                                        data.profileURL??"",
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.fullName??"",
                                        style: AppTextTheme.h3.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 3,),
                                      Row(
                                        children: [
                                          Text("@${data.username}",
                                            style: AppTextTheme.h6.copyWith(
                                                fontSize: 12,
                                                color: AppColor.g600
                                            ),),
                                          const SizedBox(width:5,),
                                          Text(RandomFunction.timeAgo(data.timestampo.toString()),
                                            style: AppTextTheme.h4.copyWith(
                                                fontSize:11,
                                                fontWeight: FontWeight.w500
                                            ),),
                                        ],
                                      ),
                                      const SizedBox(height: 12,),
                                    ],
                                  ),
                                  const Spacer(),
                                  //SvgPicture.asset("assets/icon/option.svg")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Replying to ",
                                    style: AppTextTheme.h4.copyWith(
                                        fontSize:14,
                                        color: AppColor.g500,
                                        fontWeight: FontWeight.w700
                                    ),),
                                  Text("@${widget.usersComment.username}",
                                    style: AppTextTheme.h4.copyWith(
                                        fontSize:14,
                                        color: AppColor.p200,
                                        fontWeight: FontWeight.w700
                                    ),),
                                ],
                              ),
                              const SizedBox(height: 12,),
                              Text(data.replyPost??"",
                                style: AppTextTheme.h4.copyWith(
                                    fontSize:16,
                                    color: AppColor.g900,
                                    fontWeight: FontWeight.w400
                                ),),
                              const SizedBox(height: 12,),
                              const Divider(
                                color: AppColor.g50,
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 12,),
                            ],
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child:  PhysicalModel(
                color: Colors.black,
                elevation: 10,
                child: Container(
                  height: 100,
                  width: size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 30),
                    child: Row(
                      children: [
                        ImageCacheCircle(
                          user==null?"":user.userProfile.profileUrl,
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(width: 12,),
                        Expanded(child: TextField(
                          controller: commentController,
                          onSubmitted: (e){
                            if(e.isNotEmpty){
                              postComment(e);
                            }
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add a comment ",
                              filled: true,
                              fillColor: AppColor.g30
                          ),
                        )),
                      ],
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
    Future.delayed(const Duration(milliseconds: 50),(){
      getComment();
    });
  }

  postComment(String e){
    commentController.clear();
    var model = context.read<VBlogViewModel>();
    var uid = context.read<UserViewModel>().user!.userProfile.userId;
    model.replyToComment(int.parse(widget.usersComment.commentId),
        e, userData: context.read<UserViewModel>().user!.userProfile, id: widget.post.firebaseAuthId).then((value){
      getComment();
    });
  }


  getComment(){
    context.read<VBlogViewModel>().getCommentReply(int.parse(widget.usersComment.commentId))
        .then((value){
      setState(() {
        searchResult=value;
      });
    });
  }

 Widget topComment(UsersComment data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            GestureDetector(
              onTap: (){
                if(data.firebaseAuthID.toString().isNotEmpty){
                  nav(context, ViewUserProfileScreen(
                    id: data.firebaseAuthID,
                  ));
                }

              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: ImageCacheR(
                  data.profileUrl,
                  height: 35,
                  width: 35,
                ),
              ),
            ),
            const SizedBox(width: 12,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.fullName,
                  style: AppTextTheme.h3.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3,),
                Row(
                  children: [
                    Text("@${data.username}",
                      style: AppTextTheme.h6.copyWith(
                          fontSize: 12,
                          color: AppColor.g600
                      ),),
                    const SizedBox(width:5,),
                    Text(RandomFunction.timeAgo(data.timestamp.toString()),
                      style: AppTextTheme.h4.copyWith(
                          fontSize:11,
                        fontWeight: FontWeight.w500
                      ),),
                  ],
                ),
                const SizedBox(height: 12,),
              ],
            ),
            const Spacer(),
            //SvgPicture.asset("assets/icon/option.svg")
          ],
        ),
        Row(
          children: [
            Text("Replying to ",
              style: AppTextTheme.h4.copyWith(
                  fontSize:14,
                  color: AppColor.g500,
                  fontWeight: FontWeight.w700
              ),),
            Text("@${widget.post.username}",
              style: AppTextTheme.h4.copyWith(
                  fontSize:14,
                  color: AppColor.p200,
                  fontWeight: FontWeight.w700
              ),),
          ],
        ),
        const SizedBox(height: 12,),
        Text(data.comment,
          style: AppTextTheme.h4.copyWith(
              fontSize:16,
              color: AppColor.g900,
              fontWeight: FontWeight.w400
          ),),
        const SizedBox(height: 20,),

      Row(
        children: [
          CustomAppIcon(
            onTap: (){

            },
            icon: "assets/icon/comment.svg",
            count: "",
          ),
          Column(
            children: [
              Text(" Reply (${searchResult!.length.toString()})",style: AppTextTheme.h1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w300
              ),),
              // const SizedBox(height: 5,),
              // Container(
              //   height: 1,
              //   width: 32,
              //   color: AppColor.p200,
              // )
            ],
          ),
        ],
      ),
        const SizedBox(height: 10,),
        const Divider(
          color: AppColor.g100,
          thickness: 0.5,
        ),
        const SizedBox(height: 20,),
      ],
    );
 }
}
