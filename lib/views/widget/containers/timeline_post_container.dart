import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/constant/screen_constants.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/icon/custom_app_icon.dart';

import '../../../res/color.dart';

class TimelinePostContainer extends StatelessWidget {
  const TimelinePostContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 28.h,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: CircleAvatar(
                  radius: 34,
                ),
              ),
              SizedBox(width: 12,),
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
                      Text("@annaclaramm"),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.g600
                        )
                      ),
                      Text("Sept 20"),
                    ],
                  )
                ],
              ),
              Spacer(),
              SvgPicture.asset("assets/icon/option.svg")
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          Flexible(
              child: Text(
                  AppStrings.kDummyPostText,
                style: AppTextTheme.h3,
              )
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
                icon: "assets/icon/like.svg",
                count: 213,
              ),
              Spacer(flex: 1,),
              CustomAppIcon(
                icon: "assets/icon/comment.svg",
                count: 500,
              ),
              Spacer(flex: 1,),
              SvgPicture.asset("assets/icon/share.svg"),
              Spacer(
                flex: 2,
              )
            ],
          ),
          SizedBox(height: 18.h,),
          Divider(
            color: AppColor.g50,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
