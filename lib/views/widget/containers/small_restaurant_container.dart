import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_details.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class SmallRestaurantContainer extends StatelessWidget {
  final RestaurantData restaurantData;
  const SmallRestaurantContainer({Key? key, required this.restaurantData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nav(
          context,
          RestaurantDetails(
            restaurantData: restaurantData,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          height: 178.h,
          width: 161.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: AppColor.g0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCacheR(
                restaurantData.coverPic,
                height: 97.h,
                topRadius: 6,
                topBottom: 0,
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  restaurantData.restuarantName,
                  style: AppTextTheme.h5.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/images/locations.svg"),
                    SizedBox(
                      width: 6.w,
                    ),
                    Flexible(
                      child: Text(
                        restaurantData.address,
                        softWrap: true,
                        maxLines: 2,
                        style: AppTextTheme.h5.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColor.g600
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
