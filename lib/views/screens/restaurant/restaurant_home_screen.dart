import 'package:flutter/material.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';
import 'package:platterwave/views/widget/containers/small_restaurant_container.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';

import '../../../res/color.dart';
class RestaurantHomeScreen extends StatelessWidget {
  const RestaurantHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 34.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your location",
                            style: AppTextTheme.h3.copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            children: [
                              Text("2972 Westheimer Rd. Santa... "),
                              GestureDetector(
                                onTap: (){},
                                  child: Icon(Icons.arrow_drop_down_outlined)
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 42.h,
                      width: 42.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.p300
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 34.h,
                ),
                AppTextField(
                  isSearch: true,
                  hasBorder: false,
                  fillColor: AppColor.g20,
                  hintText: "Search",
                  prefixIcon: Icon(
                      Icons.search,
                    size: 20,
                  ),
                ),
                SizedBox(height: 42.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby Restaurants",
                      style: AppTextTheme.h3.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("See More")
                  ],
                ),
                SizedBox(height: 8.h,),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Text("Selected Restaurants close to you")
                ),
                SizedBox(
                  height: 32.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: SizedBox(
                    height: 178.h,
                    child: OverflowBox(
                      maxWidth: SizeConfig.screenWidth,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index){
                            return SmallRestaurantContainer();
                          }),
                    ),
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
                      style: AppTextTheme.h3.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("See More")
                  ],
                ),
                SizedBox(height: 8.h,),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Highly recommended places for you")
                ),
                SizedBox(
                  height: 32.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: SizedBox(
                    height: 178.h,
                    child: OverflowBox(
                      maxWidth: SizeConfig.screenWidth,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index){
                            return SmallRestaurantContainer();
                          }),
                    ),
                  ),
                ),
                //TODO: Implement Carousel Slider for Discount and Promos
                SizedBox(
                  height: 42.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Restaurants",
                      style: AppTextTheme.h3.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("See More")
                  ],
                ),
                SizedBox(
                  height: 28.h,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Flexible(
                        child: LargeRestaurantContainer()
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20.h,
                    );
                  },
                  itemCount: 4,
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
