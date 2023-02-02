import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class SmallRestaurantContainer extends StatelessWidget {
  const SmallRestaurantContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        height: 178.h,
        width: 161.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColor.g0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 97.h,
              width: 161.w,
              decoration: BoxDecoration(
                color: AppColor.p300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: ClipRRect(
                //TODO: Change to Image Asset for image
                // child: Image.asset(image, fit: BoxFit.cover,),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "De Place Food",
                style: AppTextTheme.h5.copyWith(
                  fontWeight: FontWeight.bold
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset("assets/icon/location.svg"),
                  SizedBox(width: 6.w,),
                  Flexible(
                    child: Text("2118 Thornridge Cir.Connecticut 35624",
                      softWrap: true,
                      maxLines: 2,
                      style: AppTextTheme.h5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
