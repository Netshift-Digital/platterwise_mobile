import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/more_resturant.dart';
import 'package:platterwave/views/screens/restaurant/widget/banner_wid.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';
import 'package:platterwave/views/widget/containers/small_restaurant_container.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';

class RestaurantHomeScreen extends StatelessWidget {
  const RestaurantHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var resModel = context.watch<RestaurantViewModel>();
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.maxFinite, 80),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your location",
                            style: AppTextTheme.h3
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Text("2972 Westheimer Rd. Santa... "),
                              GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                      Icons.arrow_drop_down_outlined))
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 42.h,
                      width: 42.h,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColor.p300),
                    )
                  ],
                ),
              ),
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  const AppTextField(
                    isSearch: true,
                    hasBorder: false,
                    fillColor: AppColor.g20,
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    height: 42.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nearby Restaurants",
                        style: AppTextTheme.h3
                            .copyWith(fontWeight: FontWeight.w500,fontSize:
                        16.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          nav(context, const MoreRestaurant());
                        },
                        child: const Text(
                          "See More",
                          style: TextStyle(color: AppColor.p200),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                   Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Selected Restaurants close to you",
                      style: AppTextTheme.h1.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.g600
                      ),),),
                  SizedBox(
                    height: 32.h,
                  ),
                  SizedBox(
                    height: 178.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: resModel.allRestDetail.length,
                      itemBuilder: (context, index) {
                        var data = resModel.allRestDetail[index];
                        return SmallRestaurantContainer(
                          restaurantData: data,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 42.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top Rated Restaurants",
                        style: AppTextTheme.h3
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          nav(context, const MoreRestaurant());
                        },
                        child: const Text(
                          "See More",
                          style: TextStyle(color: AppColor.p200),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                 Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Highly recommended places for you",
                      style: AppTextTheme.h1.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.g600
                      ),)),
                  SizedBox(
                    height: 32.h,
                  ),
                  SizedBox(
                    height: 178.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: resModel.allRestDetail.length,
                        itemBuilder: (context, index) {
                          var data = resModel.allRestDetail[index];
                          return SmallRestaurantContainer(
                            restaurantData: data,
                          );
                        }),
                  ),
                  const BannerWidget(),
                  SizedBox(
                    height: 42.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Restaurants",
                        style: AppTextTheme.h3
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          nav(context, const MoreRestaurant());
                        },
                        child: const Text(
                          "See More",
                          style: TextStyle(color: AppColor.p200),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: resModel.allRestDetail.length,
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      var data = resModel.allRestDetail[index];
                      return LargeRestaurantContainer(
                        restaurantData: data,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 20.h,
                      );
                    },
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
