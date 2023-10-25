import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/res.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class SmallRestaurantContainer extends StatelessWidget {
  final RestaurantData restaurantData;
  final int id;
  const SmallRestaurantContainer(
      {Key? key, required this.restaurantData, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nav(
          context,
          Res(
            restaurantData: restaurantData,
            id: restaurantData.restId,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 21),
        child: Container(
          height: 218.h,
          width: 185.w,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFD6D6D6)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ImageCacheR(
                      restaurantData.coverPic,
                      topRadius: 6,
                      topBottom: 0,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: SizedBox(
                        height: 26,
                        width: 26,
                        child: GestureDetector(
                          onTap: () {
                            print("Fav rest clicked");
                            context
                                .read<RestaurantViewModel>()
                                .saveRestaurant(restaurantData);
                          },
                          child: SizedBox(
                            width: 39,
                            height: 39,
                            child: Consumer<RestaurantViewModel>(
                              builder: (context, restaurantModel, child) {
                                return restaurantModel.isFavourite(
                                        restaurantData.restId.toString())
                                    ? SvgPicture.asset('assets/icon/heart.svg')
                                    : SvgPicture.asset(
                                        'assets/icon/favour_rite.svg');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  restaurantData.restuarantName,
                  style: AppTextTheme.h5.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: SvgPicture.asset("assets/images/locations.svg"),
                    ),
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
                            color: AppColor.g600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
