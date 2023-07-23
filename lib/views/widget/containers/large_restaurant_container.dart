import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/restaurant/screen/res.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_details.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

import '../../../res/color.dart';

class LargeRestaurantContainer extends StatelessWidget {
  final RestaurantData restaurantData;
  const LargeRestaurantContainer({Key? key, required this.restaurantData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nav(
          context,
          Res(
            restaurantData: restaurantData,
          ),
        );
      },
      child: Container(
        width: 343.w,
        height: 106.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFFD6D6D6)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 99.w,
              height: 106.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
                 child: ImageCacheR(restaurantData.coverPic,
                 topBottom: 0,
                 topRadius: 0,
                 ),
              ),
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                   restaurantData.restuarantName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextTheme.h3.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 4.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: SvgPicture.asset("assets/images/locations.svg")
                      ),
                      SizedBox(width: 6.w,),
                      Flexible(
                        flex: 2,
                        child: Text(
                          restaurantData.address,
                           style: AppTextTheme.h5.copyWith(
                             fontSize: 12,
                             color: AppColor.g600,
                             fontWeight: FontWeight.w500
                           ),
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
