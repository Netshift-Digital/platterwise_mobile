import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/constant/post_type.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

import '../../../res/color.dart';

class SavedPostTile extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onOptionsTap;
  final Post post;
  const SavedPostTile({
    Key? key,
    this.onTap,
    this.onOptionsTap, required this.post
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.w),
        height: 104.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.g20,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
            padding: EdgeInsets.only(
                top: 20.h,
                left: 20.w,
                bottom: 20.h
            ),
            child: post.contentType==PostType.video?
            videoWid():post.contentType==PostType.image?ImageCacheR(
                height: 64.h,
                width: 100.w,
                post.contentUrl
            ):const SizedBox(),
          ),
          SizedBox(width: 12.w,),
            SizedBox(
              width: 166.w,
              child: Padding(
                padding:const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      post.contentPost,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                    ),
                   const SizedBox(height: 8,),
                    Text(post.username,style: AppTextTheme.h4.copyWith(
                      fontSize: 12,
                      color: AppColor.g900
                    ),)
                  ],
                ),
              ),
            ),
            SizedBox(width: 21.w,),
            Padding(
              padding: EdgeInsets.only(top: 8.h,right: 8.h),
              child: InkWell(
                onTap: onOptionsTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/icon/options.svg")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget  videoWid() {
    return Container(
      height: 64.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: AppColor.p300,
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle
      ),
      child:ImageCacheR(vidImage),
    );
  }
}

