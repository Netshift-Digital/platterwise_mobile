import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/constant/screen_constants.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';
import 'package:readmore/readmore.dart';



class TimelinePostContainer extends StatelessWidget {
  const TimelinePostContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      children: [
        SizedBox(
          height: 28.h,
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child:const CircleAvatar(
                radius: 34,
              ),
            ),
           const SizedBox(width: 12,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Esther Howard",
                  style: AppTextTheme.h3.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   const Text("@annaclaramm"),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.g600
                      )
                    ),
                    SizedBox(width: 5.w,),
                   const Text("Sept 20"),
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
          AppStrings.kDummyPostText,
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
        Container(
          height: 239.h,
          width: 343.w,
          decoration: BoxDecoration(
            color: AppColor.p300,
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle
          ),
        ),
        SizedBox(height: 18.h,),
        Row(
          children: [
            CustomAppIcon(
              onTap: (){},
              icon: "assets/icon/like.svg",
              count: 213,
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
    );
  }
}
