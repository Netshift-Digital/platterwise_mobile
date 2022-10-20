import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

import '../../../res/color.dart';

class SavedPostTile extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onOptionsTap;

  const SavedPostTile({
    Key? key,
    this.onTap,
    this.onOptionsTap
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
            child: Container(
              width: 113.w,
              height: 64.h,
              decoration: BoxDecoration(
                  color: AppColor.p300,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(width: 12.w,),
            SizedBox(
              width: 166.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Flexible(
                        child: Text(
                            "Aliqua dolor do amet sint.Velit officia conseqejnbt",
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        )
                    ),
                    Text("By Ester Howard")
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
}
