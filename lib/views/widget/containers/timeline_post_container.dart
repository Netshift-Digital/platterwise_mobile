import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:platterwave/constant/post_type.dart';
import 'package:platterwave/constant/screen_constants.dart';
import 'package:platterwave/data/local/post.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/screens/vblog/post_details.dart';
import 'package:platterwave/views/screens/vblog/video_player.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';


var vidImage = "https://www.balmoraltanks.com/images/common/video-icon-image.jpg";
List likes = [];
class TimelinePostContainer extends StatefulWidget {
  final Post post;
  final bool tap;
  const TimelinePostContainer(
      this.post,
      {this.tap=true,Key? key}) : super(key: key);

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
      onTap: (){
        if(widget.tap){
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
                  onTap: (){
                    nav(context, ViewUserProfileScreen(
                      id: widget.post.firebaseAuthId,
                    ));
                  },
                  child: ImageCacheCircle(widget.post.profileUrl,
                  height: 55,
                  width: 55,),
                ),
               const SizedBox(width: 12,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.username,
                      style: AppTextTheme.h3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       Text(RandomFunction.date(widget.post.timestamp.toString()).yMMMdjm,
                       style: AppTextTheme.h6.copyWith(
                         fontSize: 12,
                         color: AppColor.g600
                       ),),
                      ],
                    )
                  ],
                ),
                const Spacer(),
               // SvgPicture.asset("assets/icon/option.svg"),
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 2,
                      onTap: (){
                        context.read<VBlogViewModel>().savePost(widget.post);
                      },
                      // row has two child icon and text
                      child: Row(
                        children:const [
                          //Icon(Icons.),
                          SizedBox(
                            // sized box with width 10
                            width: 10,
                          ),
                          Text("Save")
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
           ReadMoreText(
             widget.post.contentPost,
              style:AppTextTheme.h3 ,
              trimLines: 2,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' Show more',
              trimExpandedText: ' Show less',
              lessStyle:const TextStyle(fontSize: 14, fontWeight: FontWeight.bold) ,
              moreStyle: const  TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 11.h,),
            widget.post.contentType==PostType.video?
                videoWid():widget.post.contentType==PostType.image?
            Container(
              height: 239.h,
              width: 343.w,
              decoration: BoxDecoration(
                color: AppColor.p300,
                borderRadius: BorderRadius.circular(15),
                shape: BoxShape.rectangle
              ),
              child: ImageCacheR(widget.post.contentUrl),
            ):const SizedBox(),
            SizedBox(height: 18.h,),
            Row(
              children: [
                CustomAppIcon(
                  onTap: (){},
                  icon: "assets/icon/like.svg",
                  like:  LikeButton(
                    isLiked:blogModel.checkIsLiked(widget.post.postId),
                    onTap: (v)async{
                      if(blogModel.checkIsLiked(widget.post.postId)==false){
                        blogModel.likePost(widget.post,context.read<UserViewModel>().user!.userProfile);
                        setState(() {
                          widget.post.likeCount=(int.parse(widget.post.likeCount)+1).toString();
                        });
                      }else{

                      }
                      setState(() {});
                    },
                  ) ,
                  count:widget.post.likeCount,
                ),
               const Spacer(flex: 1,),
                CustomAppIcon(
                  onTap: (){
                    if(widget.tap){
                      nav(context, PostDetails(post: widget.post));
                    }
                  },
                  icon: "assets/icon/comment.svg",
                  count: widget.post.commentCount,
                ),
                const Spacer(flex: 1,),
                CustomAppIcon(
                  onTap: (){
                    Share.share(widget.post.contentPost);
                  },
                  icon: "assets/icon/share.svg",
                  count:"",
                ),
               const Spacer(
                  flex: 3,
                )
              ],
            ),
            SizedBox(height: 18.h,),
            const Divider(
              color: AppColor.g50,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }

Widget  videoWid() {
    return GestureDetector(
      onTap: (){
        nav(context, VideoPlay(url: widget.post.contentUrl,));
      },
      child: Container(
        height: 239.h,
        width: 343.w,
        decoration: BoxDecoration(
            color: AppColor.p300,
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle
        ),
        child:ImageCacheR(vidImage),
      ),
    );
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      like=num.parse(widget.post.likeCount).toInt();
    });
  }
}
