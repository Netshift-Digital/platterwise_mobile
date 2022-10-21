import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:platterwave/constant/post_type.dart';
import 'package:platterwave/constant/screen_constants.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/vblog/post_details.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';
import 'package:readmore/readmore.dart';


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
                ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: ImageCacheR(
                    widget.post.profileUrl,
                    height: 50,
                    width: 54,
                  ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      // const Text("@annaclaramm"),
                      //   Container(
                      //     width: 4,
                      //     height: 4,
                      //     decoration: const BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: AppColor.g600
                      //     )
                      //   ),
                        //SizedBox(width: 5.w,),
                       Text(RandomFunction.date(widget.post.timestamp.toString()).yMMMdjm),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                SvgPicture.asset("assets/icon/option.svg")
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
                    isLiked:likes.contains(widget.post.postId),
                    onTap: (v)async{
                      if(likes.contains(widget.post.postId)){
                        likes.remove(widget.post.postId);
                       like= like-1;
                      }else{
                        likes.add(widget.post.postId);
                        like= like+1;
                      }
                      setState(() {});
                    },
                  ) ,
                  count: like,
                ),
               const Spacer(flex: 1,),
                CustomAppIcon(
                  onTap: (){},
                  icon: "assets/icon/comment.svg",
                  count: 500,
                ),
                const Spacer(flex: 1,),
                CustomAppIcon(
                  onTap: (){},
                  icon: "assets/icon/share.svg",
                  count: 500,
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
    return Container(
      height: 239.h,
      width: 343.w,
      decoration: BoxDecoration(
          color: AppColor.p300,
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle
      ),
      child:ImageCacheR(vidImage),
    );
}
}
