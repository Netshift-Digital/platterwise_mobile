import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

import '../../../res/color.dart';

class LargeRestaurantContainer extends StatelessWidget {
  const LargeRestaurantContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: 343.w,
        height: 92.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColor.g0
        ),
        child: Row(
          children: [
            Container(
              width: 99.w,
              height: 92.h,
              decoration: const BoxDecoration(
                color: AppColor.p300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: ClipRRect(
                //TODO: Change to Image Asset for Image
                // child: Image.asset(image, fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h,),
                  Text(
                    "La Cruise Restaurants",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.h3.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: SvgPicture.asset("assets/icon/location.svg")
                      ),
                      SizedBox(width: 6.w,),
                      Flexible(
                        flex: 2,
                        child: Text(
                          "2118 Thornridge Cir. Syracuse,Connecticut 35624",
                           style: AppTextTheme.h5,
                          softWrap: true,
                          maxLines: 3,
                        ),
                      )
                    ],
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
