import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_details.dart';

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
          RestaurantDetails(
            restaurantData: restaurantData,
          ),
        );
      },
      child: Card(
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
                   child: Image.network(restaurantData.coverPic, fit: BoxFit.cover,),
                ),
              ),
              SizedBox(width: 12.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.h,),
                    Text(
                     restaurantData.restuarantName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextTheme.h3.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 6.h,),
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
                            restaurantData.address,
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
      ),
    );
  }
}
