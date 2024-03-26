import 'package:flutter/material.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

import '../../../res/color.dart';
import '../button/custom-button.dart';

class FollowingFollowersTile extends StatelessWidget {
  const FollowingFollowersTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.g600
              )
          ),
          SizedBox(width: 8.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wade Warren"),
              Text("@wadewarren12")
            ],
          ),
          Spacer(),
          PlatButton(
              title: "Following",
              color: AppColor.g70,
              height: 37.h,
              width: 103.w,
              textSize: 16,
              padding: 0,
              onTap: (){}
          )
        ],
      ),
    );
  }
}
